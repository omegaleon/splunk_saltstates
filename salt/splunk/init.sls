#This was called from top.sls In there i listed "splunk" that then looks for either splunk.sls or a splunk folder. It went into the folder.. and init.sls is there so it runs it.
#You could then have init.sls call other sls files but just put stuff in here.


# Extracts a file into /opt/splunk. You can see in source instead of listing the file manually I use the pillar variable called splunk_ver to fill that in.
Extract server package:
  archive.extracted:
    - name: /opt/splunk/
    - source: salt://{{ salt['pillar.get']('splunk_ver') }}
    - archive_format: tar
    - user: splunk
    - group: splunk
    - tar_options: --strip-components=1

#Make sure the splunk user exists 
splunk:
  user.present:
    - fullname: Splunk Service Account
    - shell: /bin/bash
    - home: /opt/splunk
    - createhome: False

#Recurse the /opt/splunk folder and set the owner/group
/opt/splunk:
  file.directory:
    - user: splunk 
    - group: splunk 
    - recurse:
      - user
      - group
#Make sure all minions have the same splunk secret, and again it gets it from the pillar. This is done because the pillar contents if never stored on minions disk where this type of sls file is stored on the minion.
Enforce Splunk Secret:
  file.managed:
    - name: "/opt/splunk/etc/auth/splunk.secret"
    - user: splunk 
    - group: splunk 
    - mode: '0644'
    - contents_pillar: splunk_secret
    - onlyif: "test -d /opt/splunk/etc/auth"

#Make sure the host is set in the inputs.conf based on the systems actual host name.
#In this example I'm using a template and the jinja template language to fill it o ut.
Set input hostname for first splunk instance :
  file.managed:
    - name: /opt/splunk/etc/system/local/inputs.conf
    - user: splunk
    - group: splunk
    - mode: '0644'
    - template: jinja
    - source: salt://splunk/inputs.conf.jinja 

#Same as above but for the ihf.. just to show what that might look like. I think there might be an easier way to do this, but for now two template files.
Set input hostname for ihf1 splunk instance :
  file.managed:
    - name: /opt/splunk/etc/system/local/hf_inputs.conf
    - user: splunk
    - group: splunk
    - mode: '0644'
    - template: jinja
    - source: salt://splunk/hf_inputs.conf.jinja

