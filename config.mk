
export clearhost?=old.reddit.com
export i2pd_dat=$(PWD)"/i2pd_dat"

docker-network:
	docker network create reverseproxy-$(clearhost); true

define tinyproxy_conf
Port\t8888\n\
Listen\t0.0.0.0\n\
BindSame\tyes\n\
Timeout\t600\n\
DefaultErrorFile\t\"/usr/share/tinyproxy/default.html\"\n\
LogFile\t\"tinyproxy.log\"\n\
LogLevel\tInfo\n\
PidFile\t\"tinyproxy.pid\"\n\
MaxClients\t100\n\
MinSpareServers\t5\n\
MaxSpareServers\t20\n\
StartServers\t10\n\
MaxRequestsPerChild\t0\n\
ViaProxyName\t\"tinyproxy\"\n\
DisableViaHeader\tYes\n\
ConnectPort\t443\n\
ConnectPort\t563\n\
ConnectPort\t80\n\
ConnectPort\t8888\n\
ReversePath\t\"/\"\t\"http://$(clearhost)/\"\n\
ReverseOnly\tYes\n\
ReverseMagic\tYes\n\
#ReverseBaseURL\t\"http://127.0.0.1:8888/\"\n
endef

export tinyproxy_conf

define i2pd_tunnels_conf
[TINYPROXY]\n\
type\t=\thttp\n\
host\t=\ttinyproxy-site\n\
port\t=\t8888\n\
inport\t=\t80\n\
keys\t=\ttinyproxy-splash.dat\n
endef

export i2pd_tunnels_conf
