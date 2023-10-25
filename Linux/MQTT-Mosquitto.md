Установка брокера Mosquitto
===========================
- [Статья 1](https://codedevice.ru/posts/ubuntu-mosquitto-install)
- [Статья 2](https://dzen.ru/a/YEiOMAECa0UEAXeH)
- [Статья 3](https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-the-mosquitto-mqtt-messaging-broker-on-ubuntu-18-04-quickstart)

Добавляем репозиторий mosquitto

	sudo apt-add-repository ppa:mosquitto-dev/mosquitto-ppa

Обновляем список пакетов

	sudo apt-get update

Устанавливаем Mosquitto

	sudo apt install mosquitto mosquitto-clients

Проверяем запущена служба брокера

	sudo service mosquitto status

Настройка пароля MQTT

Для доступа по логину и паролю выполним команду (см.ниже) которая создаст файл passwd в каталоге 
`/etc/mosquitto/` и сгенерирует в нем пароль для пользователя `codedevice`.

	sudo mosquitto_passwd -c /etc/mosquitto/passwd codedevice

Добавим нового пользователя с логином `mqtt` и паролем `mqtt`:

    mosquitto_passwd -b /etc/mosquitto/passwd mqtt mqtt

Создаем свой конфигурационный файл

	sudo nano /etc/mosquitto/conf.d/default.conf

Основной файл mosquitto конфигурации находится `/etc/mosquitto/mosquitto.conf`
Скопируем в него настройки, где повесим слушателя на порт `1883`, запретим анонимный вход 
и укажет путь к файлу паролей который мы создали ранее.

	listener 1883
	allow_anonymous false
	password_file /etc/mosquitto/passwd

Открыть порт в фаерволе

    sudo ufw allow 1883

Перезапускаем `mosquitto` командой

	sudo service mosquitto restart


Поддержка SSL c использованием Let's Encrypt
--------------------------------------------

First we will install a custom software repository to get the latest version of `Certbot`, the Let’s Encrypt client:

    sudo add-apt-repository ppa:certbot/certbot

Установка `Certbot`

    sudo apt install certbot

Downloading an SSL Certificate

Open up port 80 in your firewall:

    sudo ufw allow 80

Then run Certbot to fetch the certificate.
You will be prompted to enter an email address and agree to the terms of service. 
After doing so, you should see a message telling you the process was successful and where your certificates are stored.
Be sure to substitute your server’s domain name here:

    sudo certbot certonly --standalone --preferred-challenges http -d mqtt.totalapi.io

Дать права на каталоги и файлы сертификатов

    sudo chmod -R 755 /etc/letsencrypt/{archive,live}


Сконфигурировать различные эндпоинты подключения к брокеру в файле `/etc/mosquitto/conf.d/default.conf`

    allow_anonymous false
    password_file /etc/mosquitto/passwd

    # mqtt://
    listener 1883

    # mqtt://
    listener 9991

    # mqtts://
    listener 9992
    certfile /etc/letsencrypt/live/mqtt.totalapi.io/cert.pem
    cafile /etc/letsencrypt/live/mqtt.totalapi.io/chain.pem
    keyfile /etc/letsencrypt/live/mqtt.totalapi.io/privkey.pem

    # ws://
    listener 9993
    protocol websockets

    # wss://
    listener 9994
    protocol websockets
    certfile /etc/letsencrypt/live/mqtt.totalapi.io/cert.pem
    cafile /etc/letsencrypt/live/mqtt.totalapi.io/chain.pem
    keyfile /etc/letsencrypt/live/mqtt.totalapi.io/privkey.pem

Открыть порты в фаерволе

    sudo ufw allow 1883
    sudo ufw allow 9991
    sudo ufw allow 9992
    sudo ufw allow 9993
    sudo ufw allow 9994
	
	
Configuring Certbot Renewals

`Certbot` will automatically renew our SSL certificates before they expire, but it needs to be told 
to restart the `Mosquitto` service after doing so.

Open the Certbot renewal configuration file for your domain name `/etc/letsencrypt/renewal/mqtt.totalapi.io.conf`.
Add the following `renew_hook` option on the last line of the file :
	
	renew_hook = chmod -R 644 /etc/letsencrypt/archive & chmod -R 644 /etc/letsencrypt/live & systemctl restart mosquitto

Save and close the file, then run a `Certbot` dry run to make sure the syntax is ok:

	sudo certbot renew --dry-run

If you see no errors, you’re all set. Let’s test our MQTT server next.	
