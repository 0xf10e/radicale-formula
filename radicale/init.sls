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
