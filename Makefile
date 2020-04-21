# $FreeBSD$

PORTNAME=	datadog-integrations
DISTVERSION=	7.16.0
PORTREVISION=	6
CATEGORIES=	sysutils

MAINTAINER=	admins@perceptyx.com
COMMENT=	Datadog Agent Integrations

LICENSE=	BSD3CLAUSE
LICENSE_FILE=	${WRKSRC}/LICENSE

USES=		python:3.7

LOGDIR?=	/var/log/datadog
ETCDIR=		${PREFIX}/etc/datadog

USE_GITHUB=	yes
GH_ACCOUNT=	datadog
GH_PROJECT=	integrations-core
GH_TAGNAME=	${DISTVERSION}

BUILD_DEPENDS=	${PYTHON_PKGNAMEPREFIX}setuptools>0:devel/py-setuptools@${PY_FLAVOR}

RUN_DEPENDS=	datadog-agent>=7.16.0_6:sysutils/datadog-agent.git \
		${PYTHON_PKGNAMEPREFIX}pymysql>0:databases/py-pymysql@${PY_FLAVOR} \
		${PYTHON_PKGNAMEPREFIX}redis>0:databases/py-redis@${PY_FLAVOR}

NO_BUILD=	yes
NO_ARCH=	yes

# find integrations-core -name setup.py | awk -F\/ '{print $2}' | sort | uniq | grep -v datadog_checks_dev | tr '\n' ' '
INTEGRATIONS=	active_directory activemq activemq_xml aerospike amazon_msk ambari apache aspdotnet btrfs cacti cassandra cassandra_nodetool ceph cilium cisco_aci clickhouse cockroachdb consul coredns couch couchbase crio datadog_checks_base datadog_checks_downloader datadog_checks_tests_helper directory disk dns_check docker_daemon dotnetclr druid ecs_fargate elastic envoy etcd exchange_server external_dns fluentd gearmand gitlab gitlab_runner go_expvar go-metro gunicorn haproxy harbor hdfs_datanode hdfs_namenode hive http_check hyperv ibm_db2 ibm_mq ibm_was iis istio jboss_wildfly kafka kafka_consumer kong kube_apiserver_metrics kube_controller_manager kube_dns kube_metrics_server kube_proxy kube_scheduler kubelet kubernetes kubernetes_state kyototycoon lighttpd linkerd linux_proc_extras mapr mapreduce marathon mcache mesos_master mesos_slave mongo mysql nagios network nfsstat nginx nginx_ingress_controller openldap openmetrics openstack openstack_controller oracle pdh_check pgbouncer php_fpm postfix postgres powerdns_recursor presto process prometheus rabbitmq redisdb riak riakcs sap_hana snmp solr spark sqlserver squid ssh_check statsd supervisord system_core system_swap tcp_check teamcity tls tokumx tomcat twemproxy twistlock varnish vault vertica vsphere win32_event_log windows_service wmi_check yarn zk	

# find integrations-core -name conf.yaml.example | awk -F\/ '{print $2}' | sort | uniq | grep -v datadog_checks_dev | tr '\n' ' '
CONFFILES=	active_directory activemq activemq_xml aerospike amazon_msk ambari apache aspdotnet btrfs cacti cassandra cassandra_nodetool ceph cilium cisco_aci clickhouse cockroachdb consul coredns couch couchbase crio directory dns_check docker_daemon dotnetclr druid ecs_fargate elastic envoy etcd exchange_server external_dns fluentd gearmand gitlab gitlab_runner go_expvar go-metro gunicorn haproxy harbor hdfs_datanode hdfs_namenode hive http_check hyperv ibm_db2 ibm_mq ibm_was iis istio jboss_wildfly kafka kafka_consumer kong kube_apiserver_metrics kube_controller_manager kube_dns kube_metrics_server kube_proxy kube_scheduler kubelet kubernetes kubernetes_state kyototycoon lighttpd linkerd linux_proc_extras mapr mapreduce marathon mcache mesos_master mesos_slave mongo mysql nagios nfsstat nginx nginx_ingress_controller openldap openmetrics openstack openstack_controller oracle pdh_check pgbouncer php_fpm postfix postgres powerdns_recursor presto process prometheus rabbitmq redisdb riak riakcs sap_hana snmp solr spark sqlserver squid ssh_check statsd supervisord system_core system_swap tcp_check teamcity tls tokumx tomcat twemproxy twistlock varnish vault vertica vsphere win32_event_log windows_service wmi_check yarn zk	

do-install:
	${MKDIR} ${STAGEDIR}${ETCDIR}
	${MKDIR} ${STAGEDIR}${ETCDIR}/conf.d

# Install integrations data
.for dir in ${CONFFILES}
	(cd ${WRKSRC}/${dir}; \
	${MV} datadog_checks/${dir}/data ${STAGEDIR}${ETCDIR}/conf.d/${dir}.d)
.endfor

# Install integrations
.for dir in ${INTEGRATIONS}
	(cd ${WRKSRC}/${dir}; \
	${PYTHON_CMD} setup.py bdist; \
	${TAR} -xzf dist/*.tar.gz -C ${STAGEDIR})
.endfor

.include <bsd.port.mk>
