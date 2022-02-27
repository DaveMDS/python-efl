#! /usr/bin/env python
# encoding: utf-8

import os
import sys
import time
import platform
import subprocess
import unittest
from setuptools import setup, Extension, Command
from packaging.version import Version

script_path = os.path.dirname(os.path.abspath(__file__))


# dependencies
EFL_MIN_VER = '1.26.0'
CYTHON_MIN_VERSION = '0.23.5'
CYTHON_BLACKLIST = ()


# basic utils
def read_file(rel_path):
    with open(os.path.join(script_path, rel_path)) as fp:
        return fp.read()

def cmd_output(cmd):
    p = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    p.wait()
    if p.returncode != 0:
        print('WARNING: An error occurred while running "%s" (code %s)' % (cmd, p.returncode))
        stderr_content = p.stderr.read().decode('utf-8').strip()
        if stderr_content:
            print(stderr_content)
        return ''
    return p.stdout.read().decode('utf-8').strip()

def get_version(rel_path):
    for line in read_file(rel_path).splitlines():
        if line.startswith('__version__'):
            return line.split("'")[1]
    raise SystemExit('Unable to find version string.')


# python-efl version from sources
RELEASE = get_version('efl/__init__.py')

# add git commit count for dev builds
if RELEASE.split('.')[2] == '99':
    count = cmd_output('git rev-list --count HEAD') or '0'
    RELEASE += 'a' + count
sys.stdout.write('Python-EFL: %s\n' % RELEASE)


# === check python version ===
sys.stdout.write('Checking for Python: ')
py_ver = sys.version_info
py_ver = '%s.%s.%s' % (py_ver[0], py_ver[1], py_ver[2])
if sys.hexversion < 0x020700f0:
    raise SystemExit('too old. Found: %s  Need at least 2.7.0' % py_ver)
sys.stdout.write('OK, found %s\n' % py_ver)
if sys.version_info.major == 2:
    print(
        '\n'
        'WARNING: Python 2 support is deprecated and will be removed soon.\n'
        '         You should really upgrade to python 3, NOW !\n'
        '         ...you have been warned, continue at your own risk.\n'
    )
    time.sleep(5)  # you really need to read the above message :P


# === use cython or pre-generated C files ===
USE_CYTHON = False
if os.getenv('DISABLE_CYTHON') is not None:
    if os.path.exists(os.path.join(script_path, 'efl/eo/efl.eo.c')):
        USE_CYTHON = False
    else:
        sys.exit(
            'You have requested to use pregenerated files with DISABLE_CYTHON\n'
            'but the files are not available!\n'
            'Unset DISABLE_CYTHON from your build environment and try again.'
        )
elif os.getenv('ENABLE_CYTHON') is not None:
    USE_CYTHON = True
elif not os.path.exists(os.path.join(script_path, 'efl/eo/efl.eo.c')):
    USE_CYTHON = True
elif os.path.exists(os.path.join(script_path, 'Makefile')):
    USE_CYTHON = True


# === pkg-config helper ===
def pkg_config(name, require, min_vers=None):
    try:
        sys.stdout.write('Checking for %s: ' % name)

        ver = cmd_output('pkg-config --modversion %s' % require)
        if not ver:
            raise SystemExit('Cannot find %s with pkg-config.' % name)

        if min_vers is not None:
            assert Version(ver) >= Version(min_vers)
        sys.stdout.write('OK, found %s\n' % ver)

        cflags = cmd_output('pkg-config --cflags %s' % require).split()
        libs = cmd_output('pkg-config --libs %s' % require).split()
        return (cflags, libs)
    except (OSError, subprocess.CalledProcessError):
        raise SystemExit('Did not find %s with pkg-config.' % name)
    except AssertionError:
        raise SystemExit('%s version mismatch. Found: %s  Needed %s' % (name, ver, min_vers))


ext_modules = []
py_modules = []
packages = ['efl']
common_cflags = [
    '-fno-var-tracking-assignments',  # seems to lower the mem used during build
    '-Wno-misleading-indentation',  # not needed (we don't indent the C code)
    '-Wno-deprecated-declarations',  # we bind deprecated functions
    '-Wno-unused-variable',  # eo_instance_from_object() is unused
    '-Wno-format-security',  # some cc don't like the way cython use EINA_LOG macros
    # '-Werror', '-Wfatal-errors'  # use this to stop build on first warnings
]
# remove clang unknown flags
if os.getenv('CC') == 'clang':
    common_cflags.remove('-fno-var-tracking-assignments')

# force default visibility. See phab T504
if os.getenv('CFLAGS') is not None and '-fvisibility=' in os.environ['CFLAGS']:
    os.environ['CFLAGS'] += ' -fvisibility=default'


if set(('build', 'build_ext', 'install', 'bdist', 'bdist_wheel', 'sdist')) & set(sys.argv):
    # === check cython version ===
    sys.stdout.write('Checking for Cython: ')
    if USE_CYTHON:
        # check if cython is installed
        try:
            import Cython
            import Cython.Compiler.Options
        except ImportError:
            raise SystemExit('not found! Needed >= %s' % (CYTHON_MIN_VERSION))

        # check min version
        if Version(Cython.__version__) < Version(CYTHON_MIN_VERSION):
            raise SystemExit('too old! Found %s  Needed %s' % (
                             Cython.__version__, CYTHON_MIN_VERSION))

        # check black-listed releases
        if Cython.__version__.startswith(CYTHON_BLACKLIST):
            raise SystemExit('found %s, its broken! Need another release' %
                             Cython.__version__)

        sys.stdout.write('OK, found %s\n' % Cython.__version__)
        MODULES_EXT = 'pyx'
        # Stop compilation on first error
        Cython.Compiler.Options.fast_fail = True
        # Generates HTML files with annotated source
        Cython.Compiler.Options.annotate = False
        # Set to False to disable docstrings
        Cython.Compiler.Options.docstrings = True

    else:
        sys.stdout.write('not needed, using pre-generated C files\n')
        MODULES_EXT = 'c'

    # === Eina ===
    eina_cflags, eina_libs = pkg_config('Eina', 'eina', EFL_MIN_VER)

    # === Eo ===
    eo_cflags, eo_libs = pkg_config('Eo', 'eo', EFL_MIN_VER)
    ext_modules.append(Extension(
        'efl.eo', ['efl/eo/efl.eo.' + MODULES_EXT],
        extra_compile_args=eo_cflags + common_cflags,
        extra_link_args=eo_libs
    ))

    # === Utilities ===
    ext_modules.append(Extension(
        'efl.utils.deprecated', ['efl/utils/deprecated.' + MODULES_EXT],
        extra_compile_args=eina_cflags + common_cflags,
        extra_link_args=eina_libs
    ))
    ext_modules.append(Extension(
        'efl.utils.conversions', ['efl/utils/conversions.' + MODULES_EXT],
        extra_compile_args=eo_cflags + common_cflags,
        extra_link_args=eo_libs + eina_libs
    ))
    ext_modules.append(Extension(
        'efl.utils.logger', ['efl/utils/logger.' + MODULES_EXT],
        extra_compile_args=eina_cflags + common_cflags,
        extra_link_args=eina_libs
    ))
    py_modules.append('efl.utils.setup')
    packages.append('efl.utils')

    # === Evas ===
    evas_cflags, evas_libs = pkg_config('Evas', 'evas', EFL_MIN_VER)
    ext_modules.append(Extension(
        'efl.evas', ['efl/evas/efl.evas.' + MODULES_EXT],
        extra_compile_args=evas_cflags + common_cflags,
        extra_link_args=evas_libs
    ))

    # === Ecore + EcoreFile ===
    ecore_cflags, ecore_libs = pkg_config('Ecore', 'ecore', EFL_MIN_VER)
    ecore_file_cflags, ecore_file_libs = pkg_config('EcoreFile', 'ecore-file', EFL_MIN_VER)
    ext_modules.append(Extension(
        'efl.ecore', ['efl/ecore/efl.ecore.' + MODULES_EXT],
        extra_compile_args=list(set(ecore_cflags + ecore_file_cflags + common_cflags)),
        extra_link_args=ecore_libs + ecore_file_libs
    ))

    # === Ecore Input ===
    ecore_input_cflags, ecore_input_libs = pkg_config('EcoreInput', 'ecore-input', EFL_MIN_VER)
    ext_modules.append(Extension(
        'efl.ecore_input', ['efl/ecore_input/efl.ecore_input.' + MODULES_EXT],
        extra_compile_args=ecore_input_cflags + common_cflags,
        extra_link_args=ecore_input_libs
    ))

    # === Ecore Con ===
    ecore_con_cflags, ecore_con_libs = pkg_config('EcoreCon', 'ecore-con', EFL_MIN_VER)
    ext_modules.append(Extension(
        'efl.ecore_con', ['efl/ecore_con/efl.ecore_con.' + MODULES_EXT],
        extra_compile_args=ecore_con_cflags + ecore_file_cflags + common_cflags,
        extra_link_args=ecore_con_libs
    ))

    # === Ecore X ===
    try:
        ecore_x_cflags, ecore_x_libs = pkg_config('EcoreX', 'ecore-x', EFL_MIN_VER)
    except SystemExit:
        print('Not found, will not be built')
    else:
        ext_modules.append(Extension(
            'efl.ecore_x', ['efl/ecore_x/efl.ecore_x.' + MODULES_EXT],
            extra_compile_args=ecore_x_cflags + common_cflags,
            extra_link_args=ecore_x_libs
        ))

    # === Ethumb ===
    ethumb_cflags, ethumb_libs = pkg_config('Ethumb', 'ethumb', EFL_MIN_VER)
    ext_modules.append(Extension(
        'efl.ethumb', ['efl/ethumb/efl.ethumb.' + MODULES_EXT],
        extra_compile_args=ethumb_cflags + common_cflags,
        extra_link_args=ethumb_libs
    ))

    # === Ethumb Client ===
    ethumb_cl_cflags, ethumb_cl_libs = pkg_config('Ethumb_Client', 'ethumb_client', EFL_MIN_VER)
    ext_modules.append(Extension(
        'efl.ethumb_client', ['efl/ethumb/efl.ethumb_client.' + MODULES_EXT],
        extra_compile_args=ethumb_cl_cflags + common_cflags,
        extra_link_args=ethumb_cl_libs
    ))

    # === Edje ===
    edje_cflags, edje_libs = pkg_config('Edje', 'edje', EFL_MIN_VER)
    ext_modules.append(Extension(
        'efl.edje', ['efl/edje/efl.edje.' + MODULES_EXT],
        extra_compile_args=edje_cflags + common_cflags,
        extra_link_args=edje_libs
    ))

    # === Edje_Edit ===
    ext_modules.append(Extension(
        'efl.edje_edit', ['efl/edje_edit/efl.edje_edit.' + MODULES_EXT],
        define_macros=[('EDJE_EDIT_IS_UNSTABLE_AND_I_KNOW_ABOUT_IT', None)],
        extra_compile_args=edje_cflags + common_cflags,
        extra_link_args=edje_libs
    ))

    # === Emotion ===
    emotion_cflags, emotion_libs = pkg_config('Emotion', 'emotion', EFL_MIN_VER)
    ext_modules.append(Extension(
        'efl.emotion', ['efl/emotion/efl.emotion.' + MODULES_EXT],
        extra_compile_args=emotion_cflags + common_cflags,
        extra_link_args=emotion_libs
    ))

    # === dbus mainloop integration ===
    dbus_cflags, dbus_libs = pkg_config('DBus', 'dbus-python', '0.83.0')
    ext_modules.append(Extension(
        'efl.dbus_mainloop', ['efl/dbus_mainloop/efl.dbus_mainloop.' + MODULES_EXT,
                              'efl/dbus_mainloop/e_dbus.c'],
        extra_compile_args=dbus_cflags + ecore_cflags + common_cflags,
        extra_link_args=dbus_libs + ecore_libs
    ))

    # === Elementary ===
    elm_cflags, elm_libs = pkg_config('Elementary', 'elementary', EFL_MIN_VER)
    ext_modules.append(Extension(
        'efl.elementary.__init__', ['efl/elementary/__init__.' + MODULES_EXT],
        extra_compile_args=elm_cflags + common_cflags,
        extra_link_args=elm_libs
    ))
    packages.append('efl.elementary')

    # Cythonize all ext_modules
    if USE_CYTHON:
        from Cython.Build import cythonize
        ext_modules = cythonize(
            ext_modules,
            include_path=['include'],
            compiler_directives={
                #'c_string_type': 'unicode',
                #'c_string_encoding': 'utf-8',
                'embedsignature': True,
                'binding': True,
                'language_level': 2,
            }
        )


# === setup.py test command ===
class Test(Command):
    description = 'Run all the available unit tests using efl in build/'
    user_options = []

    def initialize_options(self):
        pass

    def finalize_options(self):
        pass

    def run(self):
        sys.path.insert(0, 'build/lib.%s-%s-%d.%d' % (
                            platform.system().lower(), platform.machine(),
                            sys.version_info[0], sys.version_info[1]))
        if 'efl' in sys.modules:
            del sys.modules['efl']

        loader = unittest.TestLoader()
        suite = loader.discover('./tests')
        runner = unittest.TextTestRunner(verbosity=1, buffer=True)
        runner.run(suite)


# === setup.py build_doc command ===
try:
    from sphinx.setup_command import BuildDoc
except ImportError:
    class BuildDoc(Command):
        description = 'build docs using sphinx, that must be installed.'
        version = ''
        release = ''
        user_options = []

        def initialize_options(self):
            pass

        def finalize_options(self):
            pass

        def run(self):
            print('Error: sphinx not found')


# === setup.py clean_generated_files command ===
class CleanGenerated(Command):
    description = 'Clean C and html files generated by Cython'
    user_options = []

    def initialize_options(self):
        pass

    def finalize_options(self):
        pass

    def run(self):
        for lib in ('eo', 'evas', 'ecore', 'ecore_x', 'ecore_input', 'ecore_con', 'edje', 
                    'emotion', 'elementary', 'ethumb', 'dbus_mainloop', 'utils'):
            lib_path = os.path.join(script_path, 'efl', lib)
            for root, _dirs, files in os.walk(lib_path):
                for fname in files:
                    if fname.endswith(('.c', '.html')) and fname != 'e_dbus.c':
                        self.remove(os.path.join(root, fname))

    def remove(self, fullpath):
        print('removing %s' % fullpath.replace(script_path, '').lstrip('/'))
        os.remove(fullpath)


# === setup.py uninstall command ===
RECORD_FILE = 'installed_files-%d.%d.txt' % sys.version_info[:2]
class Uninstall(Command):
    description = 'remove all the installed files recorded at installation time'
    user_options = []

    def initialize_options(self):
        pass

    def finalize_options(self):
        pass

    def remove_entry(self, entry):
        if os.path.isfile(entry):
            try:
                print('removing file %s' % entry)
                os.unlink(entry)
            except OSError as err:
                print(err)
                return

            directory = os.path.dirname(entry)
            while os.listdir(directory) == []:
                try:
                    print('removing empty directory %s' % directory)
                    os.rmdir(directory)
                except OSError as err:
                    print(err)
                    break
                directory = os.path.dirname(directory)

    def run(self):
        if not os.path.exists(RECORD_FILE):
            print('ERROR: No %s file found!' % RECORD_FILE)
        else:
            for entry in open(RECORD_FILE).read().split():
                self.remove_entry(entry)


setup(
    name='python-efl',
    fullname='Python bindings for Enlightenment Foundation Libraries',
    description='Python bindings for Enlightenment Foundation Libraries',
    long_description=read_file('README.md'),
    long_description_content_type='text/markdown',
    version=RELEASE,
    author='Davide Andreoli, Kai Huuhko, and others',
    author_email='dave@gurumeditation.it, kai.huuhko@gmail.com',
    contact='Enlightenment developer mailing list',
    contact_email='enlightenment-devel@lists.sourceforge.net',
    url='http://www.enlightenment.org',
    license='GNU Lesser General Public License (LGPL)',
    keywords='efl wrapper binding enlightenment eo evas ecore edje emotion elementary ethumb',
    classifiers=[
        'Development Status :: 5 - Production/Stable',
        'Environment :: X11 Applications',
        'Environment :: Console :: Framebuffer',
        'Intended Audience :: End Users/Desktop',
        'License :: OSI Approved :: GNU Library or Lesser General Public License (LGPL)',
        'Operating System :: POSIX',
        'Programming Language :: C',
        'Programming Language :: Cython',
        'Programming Language :: Python :: 2',
        'Programming Language :: Python :: 3',
        'Topic :: Software Development :: Libraries :: Python Modules',
        'Topic :: Software Development :: User Interfaces',
        'Topic :: Software Development :: Widget Sets',
    ],
    cmdclass={
        'test': Test,
        'build_doc': BuildDoc,
        'clean_generated_files': CleanGenerated,
        'uninstall': Uninstall,
    },
    command_options={
        'build_doc': {
            'version': ('setup.py', RELEASE),
            'release': ('setup.py', RELEASE),
        },
        'install': {
            'record': ('setup.py', RECORD_FILE),
        },
    },
    packages=packages,
    ext_modules=ext_modules,
    py_modules=py_modules,
    zip_safe=False,
)
