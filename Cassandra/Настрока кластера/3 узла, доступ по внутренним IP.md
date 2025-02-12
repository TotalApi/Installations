Настройка кластера Apache Cassandra (3 узла, доступ по внутренним IP)
=====================================================================

### 1. Основные параметры для каждого узла  
Редактируй файл конфигурации `/etc/cassandra/cassandra.yaml` (или другой путь в зависимости от дистрибутива) на каждом узле.

#### Узел 1 (192.168.0.11)

	cluster_name: 'MyCassandraCluster'

	# IP-адрес текущего узла
	listen_address: 192.168.0.11

	# IP-адрес, на котором слушает CQL-интерфейс
	rpc_address: 192.168.0.11
	broadcast_rpc_address: 192.168.0.11

	# Список seed-нод (обычно 2–3 узла, первый узел включён)
	seed_provider:
	  - class_name: org.apache.cassandra.locator.SimpleSeedProvider
		parameters:
		  - seeds: "192.168.0.11,192.168.0.12"

	# Используем Gossip Snitch для лучшей маршрутизации
	endpoint_snitch: GossipingPropertyFileSnitch


#### Узел 2 (192.168.0.12)

	cluster_name: 'MyCassandraCluster'

	listen_address: 192.168.0.12
	rpc_address: 192.168.0.12
	broadcast_rpc_address: 192.168.0.12

	seed_provider:
	  - class_name: org.apache.cassandra.locator.SimpleSeedProvider
		parameters:
		  - seeds: "192.168.0.11,192.168.0.12"

	endpoint_snitch: GossipingPropertyFileSnitch


#### Узел 3 (192.168.0.13)

	cluster_name: 'MyCassandraCluster'

	listen_address: 192.168.0.13
	rpc_address: 192.168.0.13
	broadcast_rpc_address: 192.168.0.13

	seed_provider:
	  - class_name: org.apache.cassandra.locator.SimpleSeedProvider
		parameters:
		  - seeds: "192.168.0.11,192.168.0.12"

	endpoint_snitch: GossipingPropertyFileSnitch

---

### 2. Дополнительные важные параметры
В файле `cassandra.yaml` добавляем/изменяем:

	# Запрещаем автоматическое присвоение listen_address
	listen_on_broadcast_address: false

	# Интерфейс для клиентов (CQL)
	start_rpc: true
	rpc_allow_all_interfaces: false  # Разрешаем доступ к API только из внутренней сети
	rpc_interface: eth0  # Убедись, что указана правильная сетевая карта

	# Объём памяти, выделяемый для heap (изменяй под своё окружение)
	# Оставь пустым, если используешь автоматическое управление GC
	# max_heap_size: 4G
	# heap_newsize: 800M

	# Динамическая маршрутизация запросов
	dynamic_snitch: true
