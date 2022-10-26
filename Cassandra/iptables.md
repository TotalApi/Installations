[Установка правил iptables](https://selectel.ru/blog/setup-iptables-linux/)
=======================================================================================

- [Статья 1](https://profhelp.com.ua/content/configuring-iptables-ubuntu-1204-web-server)
- [Статья 2](https://unlix.ru/начальная-установка-и-настройка-iptables/)
- [Статья 3](https://timeweb.com/ru/community/articles/nastroyka-iptables-dlya-chaynikov)
- [Статья 4](https://tinyurl.com/23avrrx4)


Получение списка правил
-----------------------

    iptables --line-numbers -L -v -n


Удаление правила по номеру
--------------------------

    iptables -D INPUT {number}


Очистка всех правил
-------------------
    
    iptables -F
    iptables -F INPUT
    iptables -F OUTPUT


Сохранение правил
-----------------

    iptables-save > /etc/iptables/rules.v4


Создание правил
---------------

	#  Для лупбэк интерфейса разрешмем только траффик, идущий через lo0 интерфейс.
	#  Блокируем остальной траффик к 127/8, идущий не через lo0 интерфейс
	iptables -A INPUT -i lo -j ACCEPT
	iptables -A INPUT -d 127.0.0.0/8 -j REJECT

	#  Разрешаем все входящие пакеты для уже установленных подключений
	iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

	#  Разрешаем весь исходящий траффик
	#  Если вы хотите рарешить только определенный тип траффика, идущего наружу - следует изменить следующее правило
	iptables -A OUTPUT -j ACCEPT


	iptables -A INPUT -s 217.147.172.57 -j ACCEPT -m comment --comment "metrix local server"
	iptables -A INPUT -s 85.198.142.206 -j ACCEPT -m comment --comment "metrix vpn server"
	iptables -A INPUT -s 213.194.126.135 -j ACCEPT -m comment --comment "home computer"


	# Разрешаем подключение к нашему ваб серверу
	#iptables -A OUTPUT -j ACCEPT-A INPUT -p tcp --dport 80 -j ACCEPT

	# Для того, чтоб разрешить HTTPS подключения - разкомментируйте следующую строку:
	#iptables -A OUTPUT -j ACCEPT-A INPUT -p tcp --dport 443 -j ACCEPT

	# Разрешаем SSH подключения. Не забываем изменить стандартный порт на какой-нибудь другой, нестандартный.
	#iptables -A INPUT -p tcp -m state --state NEW --dport 22 -j ACCEPT
    
    # Разрешаем SSH подключения только для указанного сервера, для остальных запрещаем.
    #iptables -A INPUT -p tcp ! -s metrix.totalapi.io --dport 22 -j DROP

	# Разрешаем пиногвать наш сервер. Если хотите запретить - закомментируйте следующую строку
	iptables -A INPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT

	# Блокируем все остальные входяшие подключения.
	iptables -A INPUT -j REJECT
	iptables -A FORWARD -j REJECT

    
Вставка правил перед указанным
------------------------------

    iptables -I INPUT 4 -s 217.147.172.200 -j ACCEPT -m comment --comment "metrix local server"
	iptables -I INPUT 4 -s 85.198.142.206 -j ACCEPT -m comment --comment "metrix vpn server"
	iptables -I INPUT 4 -s 213.194.126.135 -j ACCEPT -m comment --comment "home computer"
