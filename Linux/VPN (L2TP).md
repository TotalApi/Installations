Установка L2TP (w/o IPSec) VPN-сервера
======================================

Одновременно можно настроить L2TP либо `w/o IPSec` либо с `IPSec с общим ключом`.
Для параллельной работы обоих вариантов сервисы должны работать на разных портах.


Установка пакетов
-----------------

    sudo apt update
    sudo apt install xl2tpd ppp iptables-persistent -y


Настройка `xl2tpd`
------------------

В файл `/etc/xl2tpd/xl2tpd.conf` вставить следующие строки:

    [global]
    port = 1701

    [lns default]
    ip range = 192.168.100.10-192.168.100.20
    local ip = 192.168.100.1
    refuse chap = yes
    refuse pap = no
    require authentication = yes
    name = l2tpd
    ppp debug = yes
    pppoptfile = /etc/ppp/options.xl2tpd
    length bit = yes


Настройка `PPP`
---------------

В файл `/etc/ppp/options.xl2tpd` вставить следующие строки:

    require-mschap-v2
    ms-dns 8.8.8.8
    ms-dns 1.1.1.1
    asyncmap 0
    auth
    hide-password
    lcp-echo-interval 30
    lcp-echo-failure 4


Создание пользователей
----------------------

В файл `/etc/ppp/chap-secrets` вставить следующие строки:

    имя-пользователя  l2tpd  пароль-пользователя  *


Включение IP forwarding
-----------------------

    sudo sysctl -w net.ipv4.ip_forward=1

Для постоянного применения:

    echo "net.ipv4.ip_forward = 1" | sudo tee -a /etc/sysctl.conf
    sudo sysctl -p


NAT через iptables
------------------

Проверь имя интерфейса:

    ip r | grep default

Например: `eth0` или `ens3`.

Заменив `ens3` на нужный интерфейс, а `10.10.10.0/24` на подсеть VPN, выполни:

    sudo iptables -t nat -A POSTROUTING -s 10.10.10.0/24 -o ens3 -j MASQUERADE

Чтобы сохранить:

    sudo apt install iptables-persistent;
    sudo netfilter-persistent save

или

    iptables-save > /etc/iptables/rules.v4


Перезапуск службы
-----------------

    sudo systemctl restart xl2tpd
    sudo systemctl enable xl2tpd


Настройка UFW
-------------

Открой необходимые порты:
    
    sudo ufw allow 1701/udp		comment 'L2TP'
    sudo ufw allow 4500/udp		comment 'NAT-T (IPsec)'
    sudo ufw allow 500/udp		comment 'IKE (IPsec)'

Разреши пересылку в файле `/etc/default/ufw`:

    DEFAULT_FORWARD_POLICY="ACCEPT"

Добавь в файл `/etc/ufw/before.rules` после строк 
    
    *filter
    :ufw-before-input - [0:0]
    :ufw-before-output - [0:0]
    :ufw-before-forward - [0:0]

следующие строки:

    # DNS localhost
    -A ufw-before-input -i lo -p udp --dport 53 -j ACCEPT

    # Allow ESP (IPsec)
    -A ufw-before-input -p esp -j ACCEPT

Примени изменения:

    sudo ufw reload
    