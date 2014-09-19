{% from "radicale/map.jinja" import radicale with context %}

radicale:
  pkg:
    - installed
    - name: {{ radicale.pkg }}
  service:
    - running
    - name: {{ radicale.service }}
    - enable: True
    - require:
      - file: {{ radicale.config }}
{# something's broken on FreeBSD... maybe service.mod_watch? #}
{%- if not salt['grains.get']('os_family') == 'FreeBSD' %}
    - watch:
      - file: {{ radicale.config }}
{%- endif %}

radicale-config:
  file.managed:
    - name: {{ radicale.config }}
    - user: root
    - group: radicale
    - mode: 644
    - source: salt://radicale/config.jinja
    - template: jinja
    - defaults: 
        radicale: 
{%- for key, val in radicale.items() %}
            {{ key }}: {{ val }}
{%- endfor %}
