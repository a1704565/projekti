#Asennettavat tiedostot

laptop:
  pkg.installed:
    - pkgs:
      - htop
      - openssh-client
      - firefox
      - vlc
      - gedit

#Palomuuriasetukset tuodaan tiedostopolusta

/etc/ufw/after6.rules:
  file.managed:
    - source: salt://ufw/laptop/after6.rules
    - user: root
    - group: root
    - mode: 640

/etc/ufw/after.rules:
  file.managed:
    - source: salt://ufw/laptop/after.rules
    - user: root
    - group: root
    - mode: 640

/etc/ufw/ufw.conf:
  file.managed:
    - source: salt://ufw/laptop/ufw.conf
    - user: root
    - group: root
    - mode: 644

/etc/ufw/user6.rules:
  file.managed:
    - source: salt://ufw/laptop/user6.rules
    - user: root
    - group: root
    - mode: 640

/etc/ufw/user.rules:
  file.managed:
    - source: salt://ufw/laptop/user.rules
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

