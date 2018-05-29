
build: echo host site docker-run-host docker-run-site

host: docker-network
	docker build -f Dockerfile.host \
		-t eyedeekay/eepsite-host .

docker-run-host: docker-network
	docker run -d --name reverseproxy-$(clearhost)-host \
		--network reverseproxy-$(clearhost) \
		--network-alias reverseproxy-$(clearhost)-host \
		--hostname reverseproxy-$(clearhost)-host \
		--expose 4567 \
		--link reverseproxy-$(clearhost)-site \
		-p :4567 \
		-p 127.0.0.1:7073:7073 \
		--volume $(i2pd_dat):/var/lib/i2pd:rw \
		--restart always \
		eyedeekay/eepsite-host; true

site: docker-network
	docker build -f Dockerfile \
		--build-arg "CUSER=$(clearhost)" \
		-t eyedeekay/reverseproxy-$(clearhost)-site .

docker-run-site: docker-network docker-clean-site
	docker run -d --name reverseproxy-$(clearhost)-site \
		--network reverseproxy-$(clearhost) \
		--network-alias reverseproxy-$(clearhost)-site \
		--hostname reverseproxy-$(clearhost)-site \
		-p 127.0.0.1:8888:8888 \
		--link reverseproxy-$(clearhost)-host \
		--restart always \
		eyedeekay/reverseproxy-$(clearhost)-site

docker-clean-site:
	docker rm -f reverseproxy-$(clearhost)-site; true

docker-clean-host:
	docker rm -f reverseproxy-$(clearhost)-host; true

clean: docker-clean-site docker-clean-host

echo:
	@echo "$(tinyproxy_conf)" | tr -d ' ' |  tee etc/tinyproxy/tinyproxy.conf
	@echo "$(i2pd_tunnels_conf)" | tr -d ' ' | sed 's|tinyproxy-site|reverseproxy-$(clearhost)-site|g' | tee etc/i2pd/tunnels.reverseproxy.conf

follow:
	docker logs -f reverseproxy-$(clearhost)-site

follow-host:
	docker logs -f reverseproxy-$(clearhost)-host

visit:
	http_proxy=http://127.0.0.1:4444 \
		surf http://fi6mnc5ssysdg7m6fd3vmuxltgsg2kjzyqqauiunfwz7qfnlqvdq.b32.i2p

test:
	surf 127.0.0.1:8888

admin:
	surf 127.0.0.1:7073

include config.mk
