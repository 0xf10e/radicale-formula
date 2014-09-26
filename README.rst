================
radicale-formula
================

A SaltStack_ formula to install and configure Radicale_, a simple 
CalDAV/CardDAV-server licensed under GPLv3_.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

.. note::
    
    This formula is still in beta.

.. _SaltStack: http://saltstack.org
.. _Radicale: http://radicale.org
.. _GPLv3: https://www.gnu.org/licenses/gpl.html

Available states
================

.. contents::
    :local:

``radicale``
------------

Installs the package for Radicale_, configures and starts the 
associated ``radicale`` service.

The configuration files are created using templates which are filled
with data from Pillar_ below the key ``radicale`` 
(i.e. ``pillar[radicale:auth:type]``).

.. _Pillar: http://docs.saltstack.com/en/latest/topics/pillar/index.html

Some known pillar-keys are:
  
  - ``radicale:disabled``: Set this one to 'True' if you **don't** 
    want ``radicale`` enabled as a service and started by default.

  - ``radicale:htpasswd``: A dictionary mapping a username to a 
    password hash. The type of hash Radicale expects can be set 
    via ``pillar[radicale:auth:htpasswd_encryption]`` (see below).

    **Empty by default.**

  - ``radicale:auth:type``: Authentication method. Valid choices are 
    'None' (**BAD!**), 'htpasswd', 'IMAP', 'LDAP', 'PAM', 'courier' 
    and 'http' for radicale 0.8. Version 0.9 also knows 'remote_user' 
    and 'custom'. See Authentication_ for some details.

    *For now (2014-09-25) only 'htpasswd' is known to work with this 
    formula. If you try anything else please report back.*

  - ``radicale:auth:htpasswd_filename``: The file where usernames and 
    passwords for ``radicale:auth:type == htpasswd`` are stored. 
    Location the formula defaults to depends on 
    ``grains[os_family]`` (`documentation on grains`_).

  - ``radicale:auth:htpasswd_encryption``: Algorithm by which the 
    passwords stored in ``pillar[radicale:auth:htpasswd_filename]`` 
    are obfuscated. Valid choices for radicale 0.8 and 0.9 are 
    'plain', 'crypt' and 'sha1'.

    The formula defaults to 'sha1' which is not secure but better 
    than the other choices. For better handling of credentials take 
    a look at the other choices available for ``[auth] type`` (set
    via ``pillar[radicale:auth:type]``) under Authentication_ 
    in the `Radicale User Documentation`_.

  - ``radicale:rights:type``: Valid choices are 'None' (**BAD!**), 
    'owner_only', 'owner_write', 'from_file' in radicale 0.8. Version
    0.9 also knows 'authenticated' and 'custom'. 
    See `Rights Management`_ in the `Radicale User Documentation`_ 
    for details.

    If no value is set in Pillar_ the formula defaults to 
    'owner_only'.

.. _Authentication: 
    http://radicale.org/user_documentation/#idauthentication
.. _documentation on grains:
    http://docs.saltstack.com/en/latest/topics/targeting/grains.html
.. _Rights Management: 
    http://radicale.org/user_documentation/#idrights-management
.. _Radicale User Documentation: 
    http://radicale.org/user_documentation/
