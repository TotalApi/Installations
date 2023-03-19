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

и на локальной машине выполнить команду в `redis-cli`:
    
    redis-cli 
    127.0.0.1:6379> CONFIG SET protected-mode no
    OK

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

