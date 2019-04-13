#Copyright 2019 Juha-Pekka Pulkkinen https://github.com/a1704565 GNU General Public License v3.0


#Asennettavat ohjelmistot

server:
  pkg.installed:
    - pkgs:
      - htop
      - openssh-client
      - mariadb-server
      - mariadb-client
      - samba


#Apache2 asennus ja asetukset, mikäli muutoksia on havaittu, niin apache käynnistetään uduestaan

apache2:
  pkg.installed

/var/www/html/index.html:
  file.managed:
    - source: salt://www/index.html

/etc/apache2/mods-enabled/userdir.conf:
  file.symlink:
    - target: ../mods-available/userdir.conf

/etc/apache2/mods-enabled/userdir.load:
  file.symlink:
    - target: ../mods-available/userdir.load

apache2service:
  service.running:
    - name: apache2
    - watch:
      - file: /etc/apache2/mods-enabled/userdir.conf
      - file: /etc/apache2/mods-enabled/userdir.load


#PHP asennus ja asetusten ottaminen käyttöön. Mikäli muutoksia tapahtuu, käynnistetään olennaiset palvelut uudestaan, jotta muutokset tulisivat voimaan.

php:
  pkg.installed:
    - pkgs:
      - php
      - php-pear
      - php7.2-dev
      - php7.2-zip
      - php7.2-curl
      - php7.2-gd
      - php7.2-mysql
      - php7.2-xml
      - libapache2-mod-php7.2

/etc/apache2/mods-available/php7.2.conf:
  file.managed:
    - source: salt://www/php7.2.conf

/etc/apache2/mods-available/php7.2.load:
  file.managed:
    - source: salt://www/php7.2.load

/etc/apache2/mods-enabled/php7.2.conf:
  file.symlink:
    - target: ../mods-available/php7.2.conf

/etc/apache2/mods-enabled/php7.2.load:
  file.symlink:
    - target: ../mods-available/php7.2.load

php-apache2service:
  service.running:
    - name: apache2
    - onchanges:
      - file: /etc/apache2/mods-available/php7.2.conf
      - file: /etc/apache2/mods-available/php7.2.load

/var/www/html/test.php:
  file.managed:
    - source: salt://www/test.php


#Samba asetukset

/samba/public:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

/etc/samba/smb.conf:
  file.managed:
    - source: salt://samba/smb.conf
    - user: root
    - group: root
    - mode: 644

samba-service:
  service.running:
    - name: smbd.service
    - onchanges:
      - file: /etc/samba/smb.conf


#Palomuuriasetukset palvelinympäristöön tuodaan tiedostopolusta, jos muutoksia havaitaan tiedostoissa, niin palvelu käynnistetään uudestaan, jotta muutokset tulisivat voimaan.

/etc/ufw/after6.rules:
  file.managed:
    - source: salt://ufw/server/after6.rules
    - user: root
    - group: root
    - mode: 640

/etc/ufw/after.rules:
  file.managed:
    - source: salt://ufw/server/after.rules
    - user: root
    - group: root
    - mode: 640

/etc/ufw/ufw.conf:
  file.managed:
    - source: salt://ufw/server/ufw.conf
    - user: root
    - group: root
    - mode: 644

/etc/ufw/user6.rules:
  file.managed:
    - source: salt://ufw/server/user6.rules
    - user: root
    - group: root
    - mode: 640

/etc/ufw/user.rules:
  file.managed:
    - source: salt://ufw/server/user.rules
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

