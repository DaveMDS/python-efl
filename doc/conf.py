# -*- coding: utf-8 -*-
#
# Configuration file for the Sphinx documentation builder.
#
# This file only contains a selection of the most common options. For a full
# list see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# pylint: disable=invalid-name


# -- Project information -----------------------------------------------------
try:
    from efl import __version__ as efl_version
except Exception as e:
    print('ERROR: Python EFL not found')
    print('ERROR:', e)
    exit(1)

project = 'Python EFL'
version = efl_version
release = efl_version
author = 'The Python-EFL community (see AUTHORS)'
copyright = '2008-2025, ' + author  # pylint: disable=redefined-builtin


# -- General configuration ----------------------------------------------------

# If your documentation needs a minimal Sphinx version, state it here.
needs_sphinx = '3.1'

# Add any Sphinx extension module names here, as strings. They can be extensions
# coming with Sphinx (named 'sphinx.ext.*') or your custom ones.
extensions = [
    'sphinx.ext.autodoc',
    'sphinx.ext.coverage',
]

# Add any paths that contain templates here, relative to this directory.
templates_path = ['_templates']

# The master toctree document.
# master_doc = 'index'

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
exclude_patterns = ['_build']


# -- Autodoc configuration -----------------------------------------------------

autodoc_default_options = {
    'members': True,  # show methods for classes
    'show-inheritance': True,  # show bases class
    'member-order': 'alphabetical',  # bysource, alphabetical, groupwise
    'no-undoc-members': True,  # dont show members without docstring
    'no-inherited-members': True,  # dont show members from parent classes
}
# both the class’ and the __init__ method’s docstring are concatenated
autoclass_content = 'both'

def setup(app):
    app.connect('autodoc-process-signature', autodoc_process_signature)

def autodoc_process_signature(_app, what, _name, _obj, _options, signature, return_annotation):
    """Cleanup params: remove the 'self' param and all the cython types"""

    if what not in ('function', 'method'):
        return None

    params = []
    for param in (p.strip() for p in signature[1:-1].split(',')):
        if param != 'self':
            params.append(param.rpartition(' ')[2])

    return ('(%s)' % ', '.join(params), return_annotation)


# -- Inheritance Diagram ------------------------------------------------------

try:
    import gv  # pylint: disable=unused-import
except ImportError:
    pass
else:
    extensions.append('sphinx.ext.inheritance_diagram')
    # svg scale better (look at the full elm dia)
    # but svg links are broken :(
    graphviz_output_format = 'png'  # png (default) or svg
    inheritance_graph_attrs = dict(
        bgcolor = 'gray25',  #404040
    )
    inheritance_node_attrs = dict(
        style = 'rounded',  # or 'filled',
        # fillcolor = 'gray20',  # bg color (should be #CCCCCC)
        color = 'gray10',  # border color (should be #202020)
        fontcolor = 'white',
        font = 'sans',

    )
    inheritance_edge_attrs = dict(
        color = 'dodgerblue3',  # arrow color (should be #4399FF)
        dir = 'none',  # arrow direction (back, forward, both or none)
    )


# -- Options for HTML output ---------------------------------------------------

# The theme to use for HTML and HTML Help pages.  See the documentation for
# a list of builtin themes.
#
# html_theme = 'alabaster' # Default sphinx theme
# html_theme = 'default'   # Classic python style
# html_theme = 'sphinxdoc' # Much modern sphinx style
# html_theme = 'sphinx13'  # The latest one from the sphinx site
html_theme = 'efldoc'      # Our custom EFL dark style

# Theme options are theme-specific and customize the look and feel of a theme
# further.  For a list of options available for each theme, see the
# documentation.
#html_theme_options = {}

# Add any paths that contain custom themes here, relative to this directory.
html_theme_path = ['themes']

# The name for this set of Sphinx documents.  If None, it defaults to
# "<project> v<release> documentation".
#html_title = None

# A shorter title for the navigation bar.  Default is the same as html_title.
html_short_title = 'Python EFL'

# The name of an image file (relative to this directory) to place at the top
# of the sidebar.
html_logo = 'images/logo.png'

# The name of an image file (within the static path) to use as favicon of the
# docs.  This file should be a Windows icon file (.ico) being 16x16 or 32x32
# pixels large.
html_favicon = 'images/logo.ico'

# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
html_static_path = ['images']

# If not '', a 'Last updated on:' timestamp is inserted at every page bottom,
# using the given strftime format.
html_last_updated_fmt = '%b %d, %Y'

# Custom sidebar templates, maps document names to template names.
#html_sidebars = {}

# Additional templates that should be rendered to pages, maps page names to
# template names.
#html_additional_pages = {}

# If false, no module index is generated.
#html_domain_indices = True

# If false, no index is generated.
#html_use_index = True

# If true, the index is split into individual pages for each letter.
#html_split_index = False

# If true, links to the reST sources are added to the pages.
html_show_sourcelink = False

# If true, "Created using Sphinx" is shown in the HTML footer. Default is True.
#html_show_sphinx = True

# If true, "(C) Copyright ..." is shown in the HTML footer. Default is True.
#html_show_copyright = True

# If true, an OpenSearch description file will be output, and all pages will
# contain a <link> tag referring to it.  The value of this option must be the
# base URL from which the finished HTML is served.
#html_use_opensearch = ''

# This is the file name suffix for HTML files (e.g. ".xhtml").
#html_file_suffix = None

# Output file base name for HTML help builder.
htmlhelp_basename = 'PythonEFLdoc'
