FAR на Linux
============

ВНИМАНИЕ!!! Текущая версия `2.4.1` не работает на версиях `kitty` `0.86.0.9 - 0.86.0.11` (последняя известная рабочая версия `0.86.0.8`)


Установка
---------

Для Ubuntu 22.04 предварительно необходимо добавить репозиторий (для 24.04+ этого делать не нужно):

    sudo add-apt-repository ppa:far2l-team/ppa 

Собственно установка:

    sudo apt update; sudo apt-get install far2l

Для RHEL-совместимых систем, таких как Oracle Linux, можно попробовать репозиторий Copr (аналог PPA для Fedora):

    sudo dnf copr enable polter/far2l
    sudo dnf install far2l


Запуск
------

Чтобы экземляр запущенного `FAR'а` был доступен в других сессиях:

    far2l

Чтобы экземляр запущенного `FAR'а` уничтожался вместе с сессией:

    far2l --mortal

Создание ярлыка `far` для быстрого запуска

    printf '#!/bin/bash\nsudo far2l --mortal\n' | sudo tee /bin/far; sudo chmod ugo+x /bin/far 




