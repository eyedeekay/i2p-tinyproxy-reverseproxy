
export clearhost?=reddit.com
export i2pd_dat=$(PWD)"/i2pd_dat"

docker-network:
	docker network create reverseproxy-$(clearhost); true

define tinyproxy_rules
http://*$(clearhost)\n
endef
export tinyproxy_rules

define tinyproxy_conf
Port\t8888\n\
Listen\t0.0.0.0\n\
BindSame\tyes\n\
Timeout\t60\n\
DefaultErrorFile\t\"/usr/share/tinyproxy/default.html\"\n\
LogFile\t\"tinyproxy.log\"\n\
LogLevel\tConnect\n\
PidFile\t\"tinyproxy.pid\"\n\
MaxClients\t10000\n\
MinSpareServers\t5\n\
MaxSpareServers\t20\n\
StartServers\t10\n\
MaxRequestsPerChild\t0\n\
ViaProxyName\t\"tinyproxy\"\n\
Filter\t\"rules.conf\"\n\
FilterURLs\tOn\n\
FilterExtended\tOn\n\
FilterDefaultDeny\tyes\n\
ConnectPort\t443\n\
ConnectPort\t563\n\
ConnectPort\t80\n\
ConnectPort\t8888\n\
ReversePath\t\"/\"\t\"http://$(clearhost)/\"\n\
ReverseOnly\tYes\n\
ReverseMagic\tYes\n\
#ReverseBaseURL\t\"http://fi6mnc5ssysdg7m6fd3vmuxltgsg2kjzyqqauiunfwz7qfnlqvdq.b32.i2p/\"\n
endef

export tinyproxy_conf

define i2pd_tunnels_conf
[TINYPROXY]\n\
type\t=\thttp\n\
host\t=\ttinyproxy-site\n\
port\t=\t8888\n\
keys\t=\ttinyproxy-splash.dat\n
endef

export i2pd_tunnels_conf
