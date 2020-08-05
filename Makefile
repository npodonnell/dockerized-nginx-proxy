BASE_NAME = dockerized-nginx-proxy
IMG_NAME = "$(BASE_NAME)-img"
CTR_NAME = "$(BASE_NAME)-ctr"
DOMAIN = example.com
RSA_BITS = 2048
CERT_DAYS = 365
KEY_FILE = etc/ssl/keys/$(DOMAIN).key
CSR_FILE = $(DOMAIN).csr
CERT_FILE = etc/ssl/certs/$(DOMAIN).crt

.PHONY: clean

all: certs proxy

certs:
	mkdir -p etc/ssl/keys etc/ssl/certs
	[ -f $(KEY_FILE) ] || openssl genrsa -out $(KEY_FILE) $(RSA_BITS)
	openssl req -new -key $(KEY_FILE) -out $(CSR_FILE) -subj "/CN=$(DOMAIN)"
	[ -f $(CERT_FILE) ] || openssl x509 -req -days $(CERT_DAYS) -in $(DOMAIN).csr -signkey $(KEY_FILE) -out $(CERT_FILE)
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
	-rm -f etc/ssl/keys/example.com.key etc/ssl/certs/example.com.crt
