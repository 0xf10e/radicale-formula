radicale formula
================

0.0.2a (2014-09-20)

- added a bunch of salt['pillar.get'] to config.jinja
- manage a htpasswd-file with user:hash pairs from pillar
- added logging.jinja
- create storage-directory if storage:type == filesystem

...and for some stupid reason it just won't work...

0.0.1 (2014-09-19)

- Used template-formula_ for the layout
- Installing pkg and starting service on FreeBSD works
- Added basic template for `{{ radicale.config }}` base on
  /usr/local/etc/radicale/config.sample from FreeBSD's pkg py27-radicale-0.8.1

.. _template-formula: https://github.com/saltstack-formulas/template-formula
