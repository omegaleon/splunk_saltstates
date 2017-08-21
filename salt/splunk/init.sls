Extract server package:
  archive.extracted:
    - name: /opt/splunk/
    - source: salt://{{ salt['pillar.get']('splunk_ver') }}
    - archive_format: tar
    - user: splunk
    - group: splunk
    - tar_options: --strip-components=1

splunk:
  user.present:
    - fullname: Splunk Service Account
    - shell: /bin/bash
    - home: /opt/splunk
    - createhome: False

/opt/splunk:
  file.directory:
    - user: splunk 
    - group: splunk 
    - recurse:
      - user
      - group

Enforce Splunk Secret:
  file.managed:
    - name: "/opt/splunk/etc/auth/splunk.secret"
    - user: splunk 
    - group: splunk 
    - mode: '0644'
    - contents_pillar: splunk_secret
    - onlyif: "test -d /opt/splunk/etc/auth"


Set input hostname for first splunk instance :
  file.managed:
    - name: /opt/splunk/etc/system/local/inputs.conf
    - user: splunk
    - group: splunk
    - mode: '0644'
    - template: jinja
    - source: salt://splunk/inputs.conf.jinja 


Set input hostname for ihf1 splunk instance :
  file.managed:
    - name: /opt/splunk/etc/system/local/hf_inputs.conf
    - user: splunk
    - group: splunk
    - mode: '0644'
    - template: jinja
    - source: salt://splunk/hf_inputs.conf.jinja

