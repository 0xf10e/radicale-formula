{% from "radicale/map.jinja" import radicale with context %}

radicale:
  pkg:
    - installed
    - name: {{ radicale.pkg }}
  service:
{% if no salt['pillar.get']('radicale:disabled') %}
    - running
    - enable: True
{% else %}
    - dead
    - enable: False
{% endif %}
    - name: {{ radicale.service }}
    - require:
      - file: {{ radicale.config }}
{# haven't tested Debian, maybe this should be
    os_family == Debian? #}
{% if salt['grains.get']('os') == 'Ubuntu' %}
      - file: /etc/default/radicale
{%- endif %} 
{# something's broken on FreeBSD... maybe service.mod_watch? #}
{%- if not salt['grains.get']('os_family') == 'FreeBSD' %}
    - watch:
      - file: {{ radicale.config }}
{%- endif %}

{% if salt['grains.get']('os') == 'Ubuntu' -%}
/etc/default/radicale:
  file.managed:
    src: salt://radicale/etc_default_radicale.jinja
    template: jinja
    defaults:
      disabled: {{ salt['pillar.get']('radicale:disabled',False) }}
      verbose_init: {{ salt['pillar.get']('radicale:verbose_init',True) }}
{%- endif %}

{% for file in ['config','logging'] %}
radicale-{{ file }}:
  file.managed:
    - name: {{ radicale[file] }}
    - user: root
    - group: radicale
    - mode: 644
    - source: salt://radicale/{{ file }}.jinja
    - template: jinja
    - defaults: 
        radicale: 
  {%- for key, val in radicale.items() %}
            {{ key }}: {{ val }}
  {%- endfor %}
{%- endfor %}

{# On Fedora /var/log/radicale/ is created
    during installation of the pkg. #}
{% if salt['grains.get']('os') != 'Fedora' %}
radicale-logfile:
  file.managed:
    - name: {{ radicale.logfile }}
    - user: radicale
    - group: radicale
    - mode: 640
{% endif %}

{% if salt['pillar.get']('radicale:storage:type','filesystem') == 'filesystem' %}
radicale-storage:
  file.directory:
    - name: {{ salt['pillar.get']('radicale:storage:filesystem_folder', radicale.filesystem_folder) }}
    - user: radicale
    - group: radicale
    - mode: 750
    - makedirs: True
{% endif %}

{% if salt['pillar.get']('radicale:auth:type','htpasswd') == 'htpasswd' %}
radicale-htpasswd:
  file.managed:
    - name: {{ radicale.htpasswd_filename }}
    - user: root
    - group: radicale
    - mode: 640
    - source: salt://radicale/htpasswd.jinja
    - template: jinja
    - defaults:
        htpasswd:
  {%- for user, hash in salt['pillar.get']('radicale:htpasswd', {}).items() %}
            {{ user }}: '{{ hash }}'
  {%- endfor %}
{% endif %}
