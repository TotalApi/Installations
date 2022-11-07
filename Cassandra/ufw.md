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

	sudo ufw allow from 217.147.172.57  comment 'metrix local server'

    sudo ufw allow from 217.147.172.200 comment 'metrix test server'
	sudo ufw allow from 85.198.142.206  comment 'metrix vpn server'
	sudo ufw allow from 213.194.126.135 comment 'home computer'

	sudo ufw allow proto tcp from any to any port 8086 comment 'Allow infixdDB http access'
    sudo ufw allow proto udp from any to any port 4444  comment 'Allow infixdDB udp access'

	sudo ufw allow 8086 comment 'Allow infixdDB http/udp access'
	sudo ufw allow 4444 comment 'Allow infixdDB http/udp access'

    
Вставка правил перед указанным
------------------------------

