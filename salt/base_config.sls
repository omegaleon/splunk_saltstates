#This config will apply to all systems.


#Installs a Cron under the root user, which runs the salt-call state.apply command which makes the minion ask the master for its state. 
salt-call state.apply:
  cron.present:
    - user: root
    - minute: '*/10'

#Makes sure the zsh shell is installed
zsh:
  pkg.installed:
    - pkgs:
      - zsh

#Makes sure the ssh is running
ssh:
  service.running: []

