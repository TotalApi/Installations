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

	sudo ufw allow from 217.147.172.57   # "metrix local server"
	sudo ufw allow from 85.198.142.206   # "metrix vpn server"
	sudo ufw allow from 213.194.126.135  # "home computer"

    
Вставка правил перед указанным
------------------------------

