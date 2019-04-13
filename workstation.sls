#Asennettavat tiedostot

workstation:
  pkg.installed:
    - pkgs:
      - htop
      - openssh-client
      - firefox
      - libreoffice
      - vlc
      - gedit
      - gimp
      - blender

#Palomuuriasetukset tuodaan tiedostopolusta

/etc/ufw/after6.rules:
  file.managed:
    - source: salt://ufw/workstation/after6.rules
    - user: root
    - group: root
    - mode: 640

/etc/ufw/after.rules:
  file.managed:
    - source: salt://ufw/workstation/after.rules
    - user: root
    - group: root
    - mode: 640

/etc/ufw/ufw.conf:
  file.managed:
    - source: salt://ufw/workstation/ufw.conf
    - user: root
    - group: root
    - mode: 644

/etc/ufw/user6.rules:
  file.managed:
    - source: salt://ufw/workstation/user6.rules
    - user: root
    - group: root
    - mode: 640

/etc/ufw/user.rules:
  file.managed:
    - source: salt://ufw/workstation/user.rules
    - user: root
    - group: root
    - mode: 640

ufw-service:
  cmd.run:
    - name: sudo ufw enable
    - onchanges:
      - file: /etc/ufw/after6.rules
      - file: /etc/ufw/after.rules
      - file: /etc/ufw/ufw.conf
      - file: /etc/ufw/user6.rules
      - file: /etc/ufw/user.rules

