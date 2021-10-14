Настройка сертификатов для подключения по https
===============================================

1. Все команды, приведенные ниже выполнять под правами локального администратора на компьютере где запущен сервер Navis.

2. Если у вас нет файл сертификата - можно создать и инсталлировать самоподписанный сертификат. 
   Для этого выполните команду:

    makecert -pe -ss MY -sr LocalMachine -a sha1 -sky exchange -n CN=ClientCertificate "<имя_файла_сертификата.cer>"

3. Для защиты канала связи при помощи существующего сертификата выполните команду:

    BindPort.bat "<порт_подключения>" "<имя_файла_сертификата.cer>"
или
    BindPort.bat "<порт_подключения>" "<имя_файла_сертификата.pfx>" "<пароль>"

    Пароль используется только для pfx-файлов сертификатов для их регистрации в хранилище сертификатов.
    Если пароль не указан или неверен и сертификат не установлен в хранилище сертификатов - привязка сертификата 
    к каналу связи не будет выполнена.
    Файлы сертификатов с расширением .cer не имеют закрытого ключа и не могут быть установлены. 


Примеры
-------

1. Вы используете WCF сервисы на стандартном SSL-порту 443 и у вас нет сертификата:


    makecert -pe -ss MY -sr LocalMachine -a sha1 -sky exchange -n CN=ClientCerttificate MyCert.cer    
    BindPort.bat 443 MyCert.cer 

2. Вы используете WCF сервисы на порту 88 и у вас есть сертификат NavisServicesCertificate.pfx с паролем 123:

    BindPort.bat 88 NavisServicesCertificate.pfx 123 


3. Чтобы разрешить прослушивание порта без прав администратора необходимо выполнить команду

    netsh http add urlacl url=http://+:80/totalapi/ user=Все
    netsh http add urlacl url=http://+:81/totalapi/ user=Все
    netsh http add urlacl url=http://+:9999/totalapi/ user=Все
    netsh http add urlacl url=http://+:1202/totalapi/ user=Все
    netsh http add urlacl url=http://+:1302/totalapi/ user=Все

    netsh http add urlacl url=http://+:8081/totalapi/ user=Все
