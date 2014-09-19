================
radicale-formula
================

A saltstack formula to install and configure Radicale_, a simple 
CalDAV/CardDAV-server licensed under GPLv3_.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

.. note::
    
    This formula is still in a (probably broken) alpha stage.

.. _Radicale: http://radicale.org
.. _GPLv3: https://www.gnu.org/licenses/gpl.html

Available states
================

.. contents::
    :local:

``radicale``
------------

Installs the radicale package, configures and starts the associated radicale service.
