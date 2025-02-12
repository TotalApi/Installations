Настройка кластера Apache Cassandra (3 узла, доступ по внешним IP)
==================================================================

### 1. Основные параметры для каждого узла  
Редактируй файл конфигурации `/etc/cassandra/cassandra.yaml` (или другой путь в зависимости от дистрибутива) на каждом узле.

#### Узел 1 (192.168.0.11 / 11.11.11.11)

	cluster_name: 'MyCassandraCluster'

	# Локальный IP для общения между узлами (внутренний)
	listen_address: 192.168.0.11

	# Внешний IP для клиентов и межузлового общения
	broadcast_address: 11.11.11.11
	broadcast_rpc_address: 11.11.11.11

	# Указываем seed-узлы (2–3 стабильных узла)
	seed_provider:
	  - class_name: org.apache.cassandra.locator.SimpleSeedProvider
		parameters:
		  - seeds: "22.22.22.22,33.33.33.33"

	# Используем Gossip Snitch для лучшей маршрутизации
	endpoint_snitch: GossipingPropertyFileSnitch


#### Узел 2 (192.168.0.22 / 22.22.22.22)

	cluster_name: 'MyCassandraCluster'

	listen_address: 192.168.0.22
	broadcast_address: 22.22.22.22
	broadcast_rpc_address: 22.22.22.22

	seed_provider:
	  - class_name: org.apache.cassandra.locator.SimpleSeedProvider
		parameters:
		  - seeds: "11.11.11.11,33.33.33.33"

	endpoint_snitch: GossipingPropertyFileSnitch


#### Узел 3 (192.168.0.33 / 33.33.33.33)

	cluster_name: 'MyCassandraCluster'

	listen_address: 192.168.0.33
	broadcast_address: 33.33.33.33
	broadcast_rpc_address: 33.33.33.33

	seed_provider:
	  - class_name: org.apache.cassandra.locator.SimpleSeedProvider
		parameters:
		  - seeds: "11.11.11.11,22.22.22.22"

	endpoint_snitch: GossipingPropertyFileSnitch

---

### 2. Дополнительные важные параметры
В файле `cassandra.yaml` добавляем/изменяем:

	# Разрешаем прослушку на всех интерфейсах
	listen_on_broadcast_address: true

	# Интерфейс для клиентов (CQL)
	start_rpc: true
	rpc_allow_all_interfaces: true
	rpc_address: 0.0.0.0  # Принимаем подключения на всех интерфейсах

	# Объём памяти, выделяемый для heap (изменяй под своё окружение)
	# Оставь пустым, если используешь автоматическое управление GC
	# max_heap_size: 4G
	# heap_newsize: 800M

	# Динамическая маршрутизация запросов
	dynamic_snitch: true
