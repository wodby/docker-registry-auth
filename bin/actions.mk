.PHONY: %

host ?= localhost
max_try ?= 1
wait_seconds ?= 1
delay_seconds ?= 0
command = curl -s -o /dev/null -I -w '%{http_code}' ${host}:5001 | grep -q 200
service = docker-regisrty-auth

check-ready:
	wait_for "$(command)" $(service) $(host):$(port) $(max_try) $(wait_seconds) $(delay_seconds)

check-live:
	@echo "OK"
