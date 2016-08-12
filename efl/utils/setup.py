# Copyright (C) 2007-2016 various contributors (see AUTHORS)
#
# This file is part of Python-EFL.
#
# Python-EFL is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 3 of the License, or (at your option) any later version.
#
# Python-EFL is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this Python-EFL.  If not, see <http://www.gnu.org/licenses/>.

import os
import distutils
import distutils.command.build
from distutils.log import warn, info, error


class build_extra(distutils.command.build.build):
    """ Adds the extra commands to the build target. """
    def run(self):
        if 'build_i18n' in self.distribution.cmdclass:
            self.run_command('build_i18n')
        if 'build_edc' in self.distribution.cmdclass:
            self.run_command('build_edc')
        if 'build_fdo' in self.distribution.cmdclass:
            self.run_command('build_fdo')
        distutils.command.build.build.run(self)


class build_edc(distutils.cmd.Command):
    description = 'compile all the edje themes using edje_cc'
    user_options = [('themes-dir=', 'd', 'directory that holds the themes '
                                         '(default: data/themes)'),
                    ('main-name=', 'n', 'main edc file name of the themes '
                                        '(default: main.edc)')]

    def initialize_options(self):
        self.themes_dir = None
        self.main_name = None

    def finalize_options(self):
        if self.themes_dir is None:
            self.themes_dir = 'data/themes'
        if self.main_name is None:
            self.main_name = 'main.edc'

    def run(self):
        distutils.dir_util.mkpath('build/themes', verbose=False)
        for name in os.listdir(self.themes_dir):
            edc_file = os.path.join(self.themes_dir, name, self.main_name)
            if os.path.isfile(edc_file):
                self.compile_theme(name, edc_file)

    def compile_theme(self, name, edc_file):
        """
        Compile edc file to using edje_cc, and put the generated theme file
        in the data_files list so it got installed.
        """
        theme_dir = os.path.dirname(edc_file)
        sources = []
        for root, dirs, files in os.walk(theme_dir):
            sources.extend( os.path.join(root, name) for name in files )

        edj_file = os.path.join('build', 'themes', '%s.edj' % name)
        if distutils.dep_util.newer_group(sources, edj_file):
            info('compiling theme "%s" from edc file: "%s"' % (name, edc_file))
            cmd = ['edje_cc', '-v',
                   '-id', theme_dir, '-id', os.path.join(theme_dir, 'images'),
                   '-fd', theme_dir, '-fd', os.path.join(theme_dir, 'fonts'),
                   '-sd', theme_dir, '-sd', os.path.join(theme_dir, 'sounds'),
                   edc_file, edj_file]
            self.spawn(cmd)

        info("changing mode of %s to 644", edj_file)
        os.chmod(edj_file, 0o0644) # stupid edje_cc create files as 0600 :/

        target = os.path.join('share', self.distribution.get_name(), 'themes')
        _data_files_append(self.distribution, target, edj_file)


class build_i18n(distutils.cmd.Command):
    description = 'integrate the gettext framework'
    user_options = [('domain=', 'd', 'gettext domain '
                                     '(default: distribution name)'),
                    ('po-dir=', 'p', 'directory that holds the i18n files '
                                     '(default: data/po)'),
                    ('update-pot', 'u', 'update the template using all files '
                                        'listed in POTFILES'),
                    ('merge-po', 'm', 'merge (or create) po files from template')]

    def initialize_options(self):
        self.domain = None
        self.po_dir = None
        self.update_pot = False
        self.merge_po = False

    def finalize_options(self):
        if self.domain is None:
            self.domain = self.distribution.get_name()
        if self.po_dir is None:
            self.po_dir = "data/po"

    def run(self):
        if 'LINGUAS' in os.environ:
            langs = os.environ['LINGUAS'].split()
        else:
            langs = open(os.path.join(self.po_dir, 'LINGUAS')).read().split()

        if self.update_pot:
            self.update_pot_from_sources()

        if self.merge_po:
            for lang in langs:
                self.merge_po_from_pot(lang)

        for lang in langs:
            self.compile_po(lang)

    def update_pot_from_sources(self):
        """
        Create or update the reference pot file
        """
        src_file = os.path.join(self.po_dir, 'POTFILES')
        pot_file = os.path.join(self.po_dir, '%s.pot' % self.domain)
        info('updating pot file: %s' % (pot_file))
        cmd = ['xgettext', '--language=Python', '--from-code=UTF-8',
               '--force-po', '-o', pot_file, '-f', src_file]
        self.spawn(cmd)
        
    def merge_po_from_pot(self, lang):
        """
        Merge (or create) the po file from the reference template pot file
        """
        pot_file = os.path.join(self.po_dir, '%s.pot' % self.domain)
        po_file = os.path.join(self.po_dir, '%s.po' % lang)
        if os.path.exists(po_file):
            info('merging po file: %s' % (po_file))
            cmd = ['msgmerge', '-N', '-U', '-q', po_file, pot_file]
            self.spawn(cmd)
        else:
            info('creating po file: %s' % (po_file))
            distutils.file_util.copy_file(pot_file, po_file, verbose=False)

    def compile_po(self, lang):
        """
        Compile po file to mo as needed, and put the generated mo file
        in the data_files list so it got installed.
        """
        po_file = os.path.join(self.po_dir, '%s.po' % lang)
        if not os.path.exists(po_file):
            warn('po file for lang %s do not exist yet' % lang)
            return

        mo_dir = os.path.join('build', 'locale', lang, 'LC_MESSAGES')
        mo_file = os.path.join(mo_dir, '%s.mo' % self.domain)
        distutils.dir_util.mkpath(mo_dir, verbose=False)

        if distutils.dep_util.newer(po_file, mo_file):
            info('compiling po file: %s -> %s' % (po_file, mo_file))
            cmd = ['msgfmt', '-c', po_file, '-o', mo_file]
            self.spawn(cmd)
        else:
            info('compiling po file: %s updated yet' % (po_file))

        target = os.path.join('share', 'locale', lang, 'LC_MESSAGES')
        _data_files_append(self.distribution, target, mo_file)


class build_fdo(distutils.cmd.Command):
    description = 'select freedesktop files to install (icons and desktop)'
    user_options= [('icon-dir=', 'i',
                    'icons directory (default: data/icons)'),
                   ('desk-dir=', 'd',
                    'desktop file directory (default: data/desktop)')]

    def initialize_options(self):
        self.icon_dir = None
        self.desk_dir = None

    def finalize_options(self):
        if self.icon_dir is None:
            self.icon_dir = os.path.join('data', 'icons')
        if self.desk_dir is None:
            self.desk_dir = os.path.join('data', 'desktop')

    def run(self):
        self.do_desktops()
        self.do_icons()

    def do_desktops(self):
        for f in os.listdir(os.path.join(self.desk_dir)):
            if f.endswith('.desktop'):
                desktop = os.path.join(self.desk_dir, f)
                target = 'share/applications'
                info('found desktop file: %s -> %s' % (desktop, target))
                _data_files_append(self.distribution, target, desktop)

    def do_icons(self):
        for root, dirs, files in os.walk(self.icon_dir):
            for f in files:
                if f.endswith(('.png', '.xpm', '.svg')):
                    icon = os.path.join(root, f)
                    size, cat = icon.split('/')[-3:-1]
                    target = 'share/icons/hicolor/%s/%s' % (size, cat)
                    info('found icon: %s -> %s' % (icon, target))
                    _data_files_append(self.distribution, target, icon)


class uninstall(distutils.cmd.Command):
    description = 'remove all the installed files recorded at installation time'
    user_options = [('record=', None, 'filename with list of files '
                                      '(default: installed_files.txt)')]

    def initialize_options(self):
        self.record = None

    def finalize_options(self):
        if self.record is None:
            self.record = 'installed_files.txt'

    def remove_entry(self, entry):
        if os.path.isfile(entry):
            try:
                info("removing file %s" % entry)
                os.unlink(entry)
            except OSError as e:
                error(e)

            directory = os.path.dirname(entry)
            while os.listdir(directory) == []:
                try:
                    info("removing empty directory %s" % directory)
                    os.rmdir(directory)
                except OSError as e:
                    error(e)
                directory = os.path.dirname(directory)

    def run(self):
        if not os.path.exists(self.record):
            warn('Warning: No record file found!')
            warn('  To make this command works you must add:')
            warn('  "install": {"record": ("setup.py", "installed_files.txt")}')
            warn('  to your command_options dict in setup.py')
            return
        for entry in open(self.record).read().split():
            self.remove_entry(entry)


def _data_files_append(distribution, target, files):
    """ Tiny util to append to data_files, ensuring data_file is defined """
    if not isinstance(files, (list, tuple)):
        files = (files,)
    if distribution.data_files is None:
        data_files = distribution.data_files = []
    else:
        data_files = distribution.data_files
    data_files.append((target, files))
