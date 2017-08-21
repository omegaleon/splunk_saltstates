{%- set zsh = salt['pillar.get']('zsh') -%}
{%- if zsh is defined %}
include:
  - zsh
{% for username, user in salt['pillar.get']('zsh:users', {}).items() %}
{%- set user_home_folder = zsh.get('home', '/home') + '/' + user['username'] -%}
change_shell_{{user.username}}:
  module.run:
    - name: user.chshell
    - m_name: {{ user.username }}
    - shell: /usr/bin/zsh
    - onlyif: "test -d {{ user_home_folder }} && test $(getent passwd {{ user.username }} | cut -d: -f7 ) != '/usr/bin/zsh'"

clone_oh_my_zsh_repo_{{user.username}}:
  git.latest:
    - name: https://github.com/robbyrussell/zsh.git
    - rev: master
    - target: "{{ zsh['home'] }}/{{user.username}}/.zsh"
    - unless: "test -d {{ user_home_folder }}/.zsh"
    - onlyif: "test -d {{ user_home_folder }}"
    - require_in:
      - file: zshrc_{{user.username}}
    - require:
      - pkg: zsh

set_oh_my_zsh_folder_and_file_permissions_{{user.username}}:
  file.directory:
    - name: "{{ zsh['home'] }}/{{user.username}}/.zsh"
    - user: {{user.username}}
    - group: {{user.group}}
    - file_mode: 744
    - dir_mode: 755
    - makedirs: True
    - recurse:
      - user
      - group
      - mode
    - require:
      - git: clone_oh_my_zsh_repo_{{user.username}}
    - require_in:
      - file: zshrc_{{user.username}}
    - onlyif: "test -d {{ user_home_folder }}"

zshrc_{{user.username}}:
  file.managed:
    - name: "{{ zsh['home'] }}/{{user.username}}/.zshrc"
    - source: salt://zsh/files/.zshrc.jinja2
    - user: {{ user.username }}
    - group: {{ user.group }}
    - mode: '0644'
    - template: jinja
    - onlyif: "test -d {{ user_home_folder }}"

{% endfor %}
{% endif %}
