# Copyright (C) 2007-2015 various contributors (see AUTHORS)
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
from distutils.log import warn, info, error


class build_extra(distutils.command.build.build):
    """ Adds the extra commands to the build target. """
    def run(self):
        if 'build_i18n' in self.distribution.cmdclass:
            self.run_command('build_i18n')
        distutils.command.build.build.run(self)


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

        if self.distribution.data_files is None:
            data_files = self.distribution.data_files = []
        else:
            data_files = self.distribution.data_files
        targetpath = os.path.join('share', 'locale', lang, 'LC_MESSAGES')
        data_files.append((targetpath, (mo_file,)))

