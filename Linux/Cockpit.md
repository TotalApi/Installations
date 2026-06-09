Установка системы Web-управления Cockpit
========================================

Установка 
---------

    sudo apt install cockpit


Разрешить подключаться от имени пользователя `root`
---------------------------------------------------

Чтобы разрешить подключение к Cockpit от имени пользователя `root`, выполните следующие шаги:

1. **Разрешить вход `root` через PAM (если требуется)**

   - В файле `/etc/pam.d/cockpit` закомментируйте строку:
     
        auth requisite pam_succeed_if.so uid >= 1000


2. **Разрешить `root`-подключения в конфигурации Cockpit**
   - В файле `/etc/cockpit/disallowed-users` уберите пользователя `root`.


3. **Перезапустите Cockpit**

        sudo systemctl restart cockpit


4. **Проверьте подключение**
   - Откройте Cockpit в браузере (`https://<IP-адрес>:9090`).
   - Попробуйте войти как `root`, используя пароль root-пользователя.


Исправление ошибки при обновлении системы
-----------------------------------------

В файле `/etc/netplan/50-cloud-init.yaml` следует добавить параметр 

    network:
        renderer: NetworkManager

после чего перезагрузить `netplan` и `NetworkManager`:

    sudo netplan generate
    sudo netplan apply
    sudo systemctl restart NetworkManager

необязательно (только если не помогли предыдущие команды):

отключить службу ожидания сети, управляемой `systemd-networkd`:

    sudo systemctl disable systemd-networkd-wait-online.service
    sudo systemctl mask systemd-networkd-wait-online.service

включить службу ожидания сети, управляемой `NetworkManager`:

    sudo systemctl enable NetworkManager-wait-online.service
    sudo systemctl start NetworkManager-wait-online.service

