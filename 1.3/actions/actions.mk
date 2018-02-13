host ?= localhost
port ?= 5001
max_try ?= 1
wait_seconds ?= 1
delay_seconds ?= 0
command = curl -s -o /dev/null -I -w '%{http_code}' ${host}:${port} | grep -q 200
service = docker-regisrty-auth

.PHONY: check-ready
check-ready:
	wait-for.sh "$(command)" $(service) $(host):$(port) $(max_try) $(wait_seconds) $(delay_seconds)

.PHONY: check-live
check-live:
	@echo "OK"
