FAR на Linux
============

ВНИМАНИЕ!!! Текущая версия `2.4.1` не работает на версиях `kitty` `0.86.0.9 - 0.86.0.11` (последняя известная рабочая версия `0.86.0.8`)


Установка
---------

    sudo add-apt-repository ppa:far2l-team/ppa; sudo apt update; sudo apt-get install far2l

Запуск
------

Чтобы экземляр запущенного `FAR'а` был доступен в других сессиях:

    far2l

Чтобы экземляр запущенного `FAR'а` уничтожался вместе с сессией:

    far2l --mortal

Создание ярлыка `far` для быстрого запуска

    printf '#!/bin/bash\nsudo far2l --mortal\n' | sudo tee /bin/far; sudo chmod ugo+x /bin/far 


