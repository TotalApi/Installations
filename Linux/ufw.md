[Работа с фаерволом UFW](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-18-04-ru)
=======================================================================================

Установка 
---------
    
    sudo apt install ufw


Настройка политик по умолчанию
------------------------------
    
    sudo ufw default deny incoming
    sudo ufw default allow outgoing


Активация UFW
-------------

    sudo ufw enable


Получение списка правил
-----------------------

    sudo ufw status verbose


Удаление правила по номеру
--------------------------

    sudo ufw status numbered
    sudo ufw delete {number}


Создание правил
---------------

    sudo ufw allow from 91.211.91.25    comment 'metrix test server'
    sudo ufw allow from 91.211.91.113   comment 'metrix vpn server'
    sudo ufw allow from 188.132.206.82  comment 'UA vpn server'

    sudo ufw allow from 89.200.217.199  comment 'home computer'

    sudo ufw allow proto tcp from any to any port 8086 comment 'Allow infixdDB http access'
    sudo ufw allow proto udp from any to any port 4444  comment 'Allow infixdDB udp access'

    sudo ufw allow 8086 comment 'Allow infixdDB http/udp access'
    sudo ufw allow 4444 comment 'Allow infixdDB http/udp access'

    sudo ufw allow 6379 comment 'Allow Redis http/udp access'

    sudo ufw allow 10000 comment 'Allow Chronograf access'

    sudo ufw allow from 192.168.10.0/24 'Allow Local access'
    
Вставка правил перед указанным
------------------------------

