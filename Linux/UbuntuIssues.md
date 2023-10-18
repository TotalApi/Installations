Отключение запрашивания пароля `sudo` (если нужно)
--------------------------------------------------

Добавить в файл `/etc/sudoers`:

    %sudo ALL=NOPASSWD: ALL


Ограничение доступа по IP и/или открытие порта
----------------------------------------------
    
    iptables -A INPUT -p tcp -m tcp -s {ip_address} -j ACCEPT         # open IP-address

    iptables -A INPUT -p tcp -m tcp --dport {port_number} -j ACCEPT   # open port

Save settings after rebooting: 

    apt-get install iptables-persistent


Установка статического IP
-------------------------

    $ sudo nano /etc/network/interfaces 

        auto eth0 
        iface eth0 inet static 
        address 192.168.1.201 
        netmask 255.255.255.0 
        network 192.168.1.0
        broadcast 192.168.1.255
        gateway 192.168.1.1
        #dns-nameservers 193.200.32.5 195.182.194.3

    $ sudo nano /etc/resolvconf/resolv.conf.d/base

        nameserver 193.200.32.5
        nameserver 195.182.194.3

Работа с дисками
----------------
Список подключённых дисков/разделов

    df -Th

    lsblk

[Проверка 1](https://avg-it.ru/info/articles/chkdsk-dlya-linux-ili-kak-proverit-zhyestkiy-disk/)
[Проверка 2](https://askubuntu.com/questions/1154095/how-to-mark-bad-blocks-on-hdd)

Запланировать при загрузке: 
    
	sudo touch /forcefsck

Найти bad blocks и записать их в файл: 
    
	sudo badblocks -sv /dev/sdb > /tmp/bads.txt

Найти и отметить bad blocks:
    
	sudo fsck -vcck /dev/sdbx




Процесс подключения диска к убунте 
----------------------------------

Для начала надо посмотреть, какие диски видит Linux. Для этого выполним команду

    sudo sudo fdisk -l

Из списка выберем наш новый диск. Скорее всего это будет /dev/sdb

`cfdisk` - утилита создания разделов на жестком диске Linux.
Запускаем `cfdisk`, указывая имя диска, с которым собираемся работать:

    sudo cfdisk /dev/sdb

Нажимаем на `New`, создать раздел. Выбираем `Primary` (основной)
Нажимаем `Write` и пишем `yes`

Если необходимо переразметить разделы на б/у диске, не тратя время на удаление существующих, можно запустить `cfdisk` с ключем -z:

    sudo cfdisk -z /dev/sdb

Параметр -z создаёт нулевую таблицу разделов, и позволяет сразу начать формировать новую.

Создаем файловую систему

    sudo mkfs -t ext4 /dev/sdb1

И монтируем:

    sudo mount -t ext4 /dev/sdb1 /media/sdb

Для постоянного монтирования необходимо добавить в файл `/etc/fstab` строчку

    /dev/sdb1 /media/sdb auto defaults 1 2

Для каталога Cassandra на внешнем диске рекомендуется 

    /dev/sdb1 /var/lib/cassandra/data auto defaults,nofail,nobootwait 0 2



Доступ по FTP (proFTPd)
-----------------------

    apt-get install proftpd

Для доступа под root'ом в `/etc/proftpd/proftpd.conf` 

    DefaultRoot ~             # что бы пользователи не могли выйти из домашнего каталога.
    
    RootLogin off             # пользователь root не может зайти на сервер. Если нету добавляем.

    RequireValidShell on      # пользователи кому запрещен shell не могут войти.

    AllowOverwrite on         # перезапись файлов разрешена.

    PassivePorts 49152 65534  # разрешить пассивный режим

в `/etc/ftpusers` удалить пользователя `root`

Перезапуск службы: `/etc/init.d/proftpd restart`





Для развертывания пакетов необходимо установить менеджер пакетов 
----------------------------------------------------------------

    sudo apt-get install aptitude
    sudo aptitude update


Установка времени
-----------------

    date +"%c"
    date +%T -s "10:13:13"


Подключиться к виндовой шаре
----------------------------

    sudo mount.cifs //192.168.1.54/Install /usr/win-share -o user=user
    sudo mount -t cifs //192.168.1.54/d /usr/win-share/d -o vers=2.0,username=lionsoft,password=Zonex1111

может не сработать, тогда надо подымать самбу:


Особенности установки Samba
---------------------------

[Ссылка 1](https://1cloud.ru/help/network/nastroika-samba-v-lokalnoj-seti)
[Ссылка 2](http://www.howtogeek.com/howto/ubuntu/install-samba-server-on-ubuntu/)

    apt-get install -y samba samba-client

    mkdir -p /samba/public
    cd /samba
    chmod -R 0777 public # важно установить для папки именно такие права, чтобы в ней можно было изменять/создавать файлы

В конфигурационном файле `/etc/samba/smb.conf` прописать следующие данные

    [global]
        workgroup = WORKGROUP
        security = user             
        map to guest = bad user     
        wins support = no           
        dns proxy = no              

    [cassandra]
        path = /var/lib/cassandra
        guest ok = yes
        force user = nobody
        browsable = yes
        writable = yes
        directory mask = 0777

Перезапустить службу после конфигурации:

    service smbd restart

Разрешить доступ в фаерволе

Для указанных портов всех IP-адресов:

    iptables -A INPUT -p tcp -m tcp --dport 445 -j ACCEPT
    iptables -A INPUT -p tcp -m tcp --dport 139 -j ACCEPT
    iptables -A INPUT -p udp -m udp --dport 137 -j ACCEPT
    iptables -A INPUT -p udp -m udp --dport 138 -j ACCEPT

Для указанных портов указанных IP-адресов:

    iptables -A INPUT -p tcp -m tcp --dport 445 -s 194.28.183.120 -j ACCEPT
    iptables -A INPUT -p tcp -m tcp --dport 139 -s 194.28.183.120 -j ACCEPT
    iptables -A INPUT -p udp -m udp --dport 137 -s 194.28.183.120 -j ACCEPT
    iptables -A INPUT -p udp -m udp --dport 138 -s 194.28.183.120 -j ACCEPT

Для всех портов с указанных IP-адресов:

    iptables -A INPUT -p tcp -m tcp -s 213.194.126.135 -j ACCEPT
    iptables -A INPUT -p tcp -m tcp -s 213.194.126.135 -j ACCEPT


Теперь необходимо сделать так, чтобы указанные выше правила фаервола iptables были сохранены после перезагрузки машины. 
Для это установим пакет `iptables-persistent`:

    apt-get install iptables-persistent

После установки откроется окно с предложением последовать запомнить текущие правила iptables для IPv4 и IPv6. Подтвердите это действие.

Проверить актуальные правила iptables можно командой:

    iptables -L


Установить монитор ресурсов
---------------------------

    sudo apt-get install htop
    htop

