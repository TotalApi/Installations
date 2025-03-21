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

    sudo ufw allow from xxx.xxx.xxx.xxx   comment 'metrix test server'
    sudo ufw allow from xxx.xxx.xxx.xxx   comment 'metrix vpn server'
    sudo ufw allow from xxx.xxx.xxx.xxx   comment 'UA vpn server'
    sudo ufw allow from xxx.xxx.xxx.xxx   comment 'home computer'

    sudo ufw allow from 192.168.10.0/24 comment 'Allow Local access'

    sudo ufw allow proto tcp from any to any port 8086 comment 'Allow infixdDB http access'
    sudo ufw allow proto udp from any to any port 4444  comment 'Allow infixdDB udp access'

    sudo ufw allow 8086 comment 'Allow infixdDB http access'
    sudo ufw allow 4444 comment 'Allow infixdDB udp access'
    sudo ufw allow 8088 comment 'Allow infixdDB subscription tcp access'

    sudo ufw allow 6379 comment 'Allow Redis access'

    sudo ufw allow 10000 comment 'Allow Chronograf access'

    
Вставка правил перед указанным
------------------------------

