[Установка Aerospike](https://aerospike.com/download/server/community/?utm_source=trynow&utm_medium=website)
===========================================================================


Установка 
---------

Ubuntu 20.04 
- v.6.1.0

        wget -O aerospike.tgz 'https://download.aerospike.com/artifacts/aerospike-server-community/6.1.0.47/aerospike-server-community-6.1.0.47-ubuntu20.04.tgz'

Ubuntu 22.04 
- v.6.3.0

        wget -O aerospike.tgz 'https://download.aerospike.com/artifacts/aerospike-server-community/6.3.0.35/aerospike-server-community_6.3.0.35_tools-8.5.1_ubuntu20.04_x86_64.tgz'

- v.6.4.0

        wget -O aerospike.tgz 'https://download.aerospike.com/artifacts/aerospike-server-community/6.4.0.30/aerospike-server-community_6.4.0.30_tools-10.0.0_ubuntu22.04_x86_64.tgz'

- v.7.2.0

        wget -O aerospike.tgz 'https://download.aerospike.com/artifacts/aerospike-server-community/7.2.0/aerospike-server-community_7.2.0.8_tools-11.2.0_ubuntu24.04_x86_64.tgz'

- v.8.0.0

        wget -O aerospike.tgz 'https://download.aerospike.com/artifacts/aerospike-server-community/8.0.0/aerospike-server-community_8.0.0.5_tools-11.2.0_ubuntu24.04_x86_64.tgz'

После скачивания:

    tar -xvf aerospike.tgz

    cd ./aerospike-server-community_*

    sudo ./asinstall


Configure Aerospike Database
----------------------------

The default location of the configuration file is `/etc/aerospike/aerospike.conf`.


Автозапуск
----------
    sudo systemctl enable aerospike

    service aerospike start


Проверить, что всё работает можно командой в `asinfo`
-----------------------------------------------------

    asinfo -v status

    asadm -e "info namespace"

    asadm -e "info network"


Консоль AQL
-----------

    aql

    aql -h <IP_адрес> -p 3000


Создание namespace
------------------

1. Добавить namespace в конфигурацию

Открываем конфиг `/etc/aerospike/aerospike.conf` и добавляем:

    namespace totalapi_cache {
        replication-factor 2
        memory-size 4G
        default-ttl 0  # 0 = без удаления по времени
        storage-engine memory
    }

Если нужны **долговременные данные**, можно добавить дисковое хранилище:

    storage-engine device {
        file /opt/aerospike/data/totalapi_cache.dat
        filesize 8G
        data-in-memory true
    }

2. После внесения изменений перезапускаем Aerospike:

    sudo service aerospike restart


3. Проверить, что namespace появился

    aql> SHOW NAMESPACES;


Конфигурация кластера
---------------------

На **каждом** сервере меняем конфиг `/etc/aerospike/aerospike.conf`:

    service {
        clustering {
            mode mesh
            mesh-seed-address-port 192.168.1.1 3002
            mesh-seed-address-port 192.168.1.2 3002
            mesh-seed-address-port 192.168.1.3 3002
        }
    }

    namespace cache {
        replication-factor 2
        memory-size 4G
        default-ttl 1h  # Кеш с автоудалением через 1 час
        storage-engine memory
    }

Запускаем Aerospike с новой конфигурацией:
    
    sudo servcie aerospike restart


Проверка кластера
-----------------

На любом сервере запустить:

    asadm -e "info"

Вы должны увидеть 3 узла в кластере.

