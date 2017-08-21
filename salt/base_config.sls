salt-call state.apply:
  cron.present:
    - user: root
    - minute: '*/10'


zsh:
  pkg.installed:
    - pkgs:
      - zsh

ssh:
  service.running: []

