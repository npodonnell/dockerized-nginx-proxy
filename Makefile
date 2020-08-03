BASE_NAME = dockerized-nginx-proxy
IMG_NAME = "$(BASE_NAME)-img"
CTR_NAME = "$(BASE_NAME)-ctr"
DOMAIN = example.com
RSA_BITS = 2048
CERT_DAYS = 365

.PHONY: clean

certs:
	mkdir -p etc/ssl/keys etc/ssl/certs
	openssl genrsa -out etc/ssl/keys/$(DOMAIN).key $(RSA_BITS) && \
	openssl req -new -key etc/ssl/keys/$(DOMAIN).key -out $(DOMAIN).csr -subj "/CN=$(DOMAIN)" && \
	openssl x509 -req -days $(CERT_DAYS) -in $(DOMAIN).csr -signkey etc/ssl/keys/$(DOMAIN).key -out etc/ssl/certs/$(DOMAIN).crt && \
	rm $(DOMAIN).csr

proxy: certs Dockerfile .dockerignore etc/**/*
	docker build -t $(IMG_NAME) .

up: down proxy
	docker create -it -p 80:80 -p 443:443 --name $(CTR_NAME) $(IMG_NAME) && \
	docker start $(CTR_NAME)

down:
	-docker stop $(CTR_NAME)
	-docker rm $(CTR_NAME)

debug:
	docker exec -it $(CTR_NAME) /bin/sh

clean: down
	-docker rmi $(IMG_NAME)
	-rm -f etc/ssl/keys/$(DOMAIN).key etc/ssl/certs/$(DOMAIN).crt
