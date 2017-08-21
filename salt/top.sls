#top.sls file is the top of the tree.. the main file called for saltstates or pillar.

#For the base environment. all minions.. apply splunk, base_config, and zsh (this is me just trying some other stuff
base:
  '*':
    - splunk
    - base_config
    - zsh
