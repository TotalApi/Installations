[Установка Redis](https://redis.io/docs/getting-started/installation/install-redis-on-windows/)
=======================================================================================

Установка 
---------
    
    curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg

    echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list

    sudo apt-get update
    sudo apt-get install redis

    sudo service redis-server start

Автозапуск
----------
    sudo systemctl enable redis-server


Проверить, что всё работает можно командой в `redis-cli`
--------------------------------------------------------

    redis-cli 
    127.0.0.1:6379> ping
    PONG


Для возможности удалённого подключения изменить в файле `/etc/redis/redis.conf`
-------------------------------------------------------------------------------

    bind 127.0.0.1 ::1 -> bind 0.0.0.0 ::

и, для возможности подключаться без пароля, на локальной машине выполнить команду в `redis-cli`:
    
    redis-cli    
    127.0.0.1:6379> CONFIG SET protected-mode no
    OK

    127.0.0.1:6379> CONFIG REWRITE
    OK

    redis-cli -h server1 -p 7000
    server1:7000> 


Список некоторых команд Redis
=============================

    KEYS *          # Cписок всех ключей
    GET {key}       # Получить значение ключа
    SET {key} {val} # Установить значение ключа
    FLUSHDB [ASYNC] # Очистка текущей БД
    FLUSHALL        # Очистка всех БД
    INFO memory     # Данные ою использовании памяти
    INFO keyspace   # Информация о ключах в каждой базе данных




Настройка Redis Cluster на 3 серверах
=====================================

1. Установи Redis на всех трёх серверах
---------------------------------------

На **каждом сервере**:

    sudo apt update
    sudo apt install redis-server -y

Редактируем конфиг `/etc/redis/redis.conf`:

    cluster-enabled yes
    cluster-config-file nodes.conf
    cluster-node-timeout 5000
    appendonly yes
    bind 0.0.0.0

Перезапускаем Redis:

    sudo service redis-server restart 

---

2. Запуск Redis на портах (для кластера нужно 6 узлов, поэтому запустим 2 инстанса на сервере)
----------------------------------------------------------------------------------------------

На **каждом сервере** (192.168.1.1, 192.168.1.2, 192.168.1.3):

    mkdir -p /etc/redis/7000 /etc/redis/7001
    cp /etc/redis/redis.conf /etc/redis/7000/redis.conf
    cp /etc/redis/redis.conf /etc/redis/7001/redis.conf

Редактируем порты и директории в конфигах:

    sed -i 's/^port .*/port 7000/' /etc/redis/7000/redis.conf
    sed -i 's/^dir .*/dir \/var\/lib\/redis7000/' /etc/redis/7000/redis.conf

    sed -i 's/^port .*/port 7001/' /etc/redis/7001/redis.conf
    sed -i 's/^dir .*/dir \/var\/lib\/redis7001/' /etc/redis/7001/redis.conf

Запускаем инстансы Redis:

    redis-server /etc/redis/7000/redis.conf &
    redis-server /etc/redis/7001/redis.conf &

---

3. Создание кластера
--------------------

Теперь на **любом сервере** выполняем команду:

    redis-cli --cluster create 192.168.1.1:7000 192.168.1.2:7000 192.168.1.3:7000 \
        192.168.1.1:7001 192.168.1.2:7001 192.168.1.3:7001 --cluster-replicas 1

Эта команда создаст **3 мастера** (7000-й порт на каждом сервере) и **3 реплики** (7001-й порт на каждом сервере).

---

4. Проверка кластера
--------------------

Смотрим статус кластера:  

    redis-cli -c -p 7000 cluster nodes


Тестируем запись/чтение:

    redis-cli -c -p 7000 set testkey "Hello, Redis!"
    redis-cli -c -p 7001 get testkey

---


Redis сам распределяет реплики так, чтобы:

- Реплика не находилась на том же сервере, что и её мастер.
- Реплики распределялись равномерно между доступными узлами.


Если необходимо ручное управление:

[Подключение slave-ноды к основному узлу](https://mohewedy.medium.com/redis-cluster-configurations-by-example-5480a178e884)
---------------------------------------------------------------------------------------------------------------------------

    redis-cli 
    127.0.0.1:6379> REPLICAOF host 6379
    OK

[Отключение slave-ноды]
-----------------------

    redis-cli 
    127.0.0.1:6379> REPLICAOF NO ONE
    OK



