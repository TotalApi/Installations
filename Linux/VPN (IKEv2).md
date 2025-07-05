Установка IKEv2/IpSec
=====================

Установка StrongSwan
--------------------

    sudo apt install strongswan strongswan-pki libcharon-extra-plugins libcharon-extauth-plugins libstrongswan-extra-plugins libtss2-tcti-tabrmd0


Создайте корневой сертификат CA
-------------------------------

    sudo ipsec pki --gen --type rsa --size 4096 --outform pem > /etc/ipsec.d/private/ca.key.pem
    sudo ipsec pki --self --ca --lifetime 3650 --in /etc/ipsec.d/private/ca.key.pem --type rsa --dn "CN=VPN CA" --outform pem > /etc/ipsec.d/cacerts/ca.cert.pem


Создайте ключ и сертификат для сервера
--------------------------------------
В данном примере используется домен сервера `scylla.totalapi.io`.

    sudo ipsec pki --gen --type rsa --size 4096 --outform pem > /etc/ipsec.d/private/server.key.pem
    
    sudo ipsec pki --pub --in /etc/ipsec.d/private/server.key.pem --type rsa | sudo ipsec pki --issue --lifetime 1825 --cacert /etc/ipsec.d/cacerts/ca.cert.pem --cakey /etc/ipsec.d/private/ca.key.pem --flag serverAuth --flag ikeIntermediate --outform pem \
    --dn "CN=scylla.totalapi.io" --san "scylla.totalapi.io" > /etc/ipsec.d/certs/server.cert.pem

Замените `scylla.totalapi.io` на ваш домен или IP-адрес сервера.


Убедитесь, что файлы в `/etc/ipsec.d/private/` доступны только для `root`
-------------------------------------------------------------------------

    sudo chmod 600 /etc/ipsec.d/private/*


Отредактируйте файл конфигурации `/etc/ipsec.conf` для использования сертификатов
---------------------------------------------------------------------------------

    # /etc/ipsec.conf
    config setup
        charondebug="ike 2, knl 2, cfg 2, net 2, esp 2, dmn 2, mgr 2"
        uniqueids=no

    conn ikev2-vpn
    
        left=%any
        # тут нужно указать домен сервера, который использовался при создании сертификата
        leftid=scylla.totalapi.io  
        leftcert=server.cert.pem
        leftsendcert=always
        leftsubnet=0.0.0.0/0

        right=%any
        rightid=%any
        rightauth=eap-mschapv2
        # тут нужно указать диапазон IP-адресов, который будет использоваться при создании VPN-подключения
        rightsourceip=192.168.100.0/24
        rightdns=8.8.8.8,8.8.4.4
        rightsendcert=never
    
        eap_identity=%identity

        auto=add
        compress=no
        type=tunnel
        keyexchange=ikev2
        fragmentation=yes
        forceencaps=yes

        dpdaction=clear
        dpddelay=300s
        rekey=no

        ike=chacha20poly1305-sha512-curve25519-prfsha512,aes256gcm16-sha384-prfsha384-ecp384,aes256-sha1-modp1024,aes128-sha1-modp1024,3des-sha1-modp1024!
        esp=chacha20poly1305-sha512,aes256gcm16-ecp384,aes256-sha256,aes256-sha1,3des-sha1!


Настройте файл `/etc/ipsec.secrets` для указания приватного ключа
-----------------------------------------------------------------

    # /etc/ipsec.secrets
    : RSA "server.key.pem"
    your-username : EAP "your-password"

Замените `your-username` и `your-password` на желаемые учетные данные.


Включение переадресации IP
--------------------------
В файле `/etc/sysctl.conf` раскомментируйте или добавьте строки:
	
	# /etc/sysctl.conf
	net.ipv4.ip_forward=1
	net.ipv6.conf.all.forwarding=1	
	
Примените изменения:

	sudo sysctl -p		


Настройка брандмауэра (UFW)
---------------------------

    sudo ufw allow 4500/udp		comment 'NAT-T (IPsec)'
    sudo ufw allow 500/udp		comment 'IKE (IPsec)'

Подключение к самому серверу через VPN возможно только по внутреннему IP-адресу и подсеть VPN должна быт добавлена в правила:

    sudo ufw allow from 192.168.100.0/24  comment 'Allow VPN access'



NAT через `iptables`
--------------------

Проверь имя интерфейса:

    ip r | grep default

Например: `eth0` или `ens3`.

Заменив `ens3` на нужный интерфейс, а `192.168.100.0/24` на подсеть VPN, выполни:

    sudo iptables -t nat -A POSTROUTING -s 192.168.100.0/24 -o ens3 -j MASQUERADE

Чтобы сохранить:

    sudo apt install iptables-persistent;
    sudo netfilter-persistent save

или

    iptables-save > /etc/iptables/rules.v4


Альтернативная настройка NAT через UFW
--------------------------------------

В файле `/etc/ufw/before.rules` в секцию `*nat` после `:POSTROUTING ACCEPT [0:0]` и перед `COMMIT` добавьте правило маскарадинга:

    -A POSTROUTING -s 192.168.100.0/24 -o ens3 -j MASQUERADE

Указанный тут диапазон IP-адресов должен совпадать с тем, что указан в `/etc/ipsec.conf` в `rightsourceip`, 
а название сетевого интерфейса (`ens3`) совпадать с названием, полученным при вызове `ip r | grep default`.

Если такой секции нет - создайте её в самом начале файла. Секция в итоге должна выглядеть примерно так:

    *nat
    :POSTROUTING ACCEPT [0:0]
    #
    # Add rules for VPN (L2TP/IPsec)
    -A POSTROUTING -s 192.168.100.0/24 -o ens3 -j MASQUERADE
    # End VPN rules
    COMMIT
    

После настройки перезапустите сервис
------------------------------------

    sudo systemctl restart strongswan-starter && sudo systemctl enable strongswan-starter


Просмотр логов для отладки
--------------------------

    sudo journalctl -u strongswan-starter -f


Настройка клиента Windows 11
----------------------------

Экспортируйте CA сертификат с сервера:

    sudo cp /etc/ipsec.d/cacerts/ca-cert.pem ~/ca-cert.pem

Затем скопируйте его на компьютер с Windows.

На Windows 11 Импортируйте `ca-cert.pem` в "Сертификаты (локальный компьютер)" → "Доверенные корневые центры сертификации" → "Сертификаты"

    certlm.msc

Сертификат должен быть установлени именно в хранилище локального компьютера (НЕ пользователя)!


