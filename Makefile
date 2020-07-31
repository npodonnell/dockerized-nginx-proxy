BASE_NAME = dockerized-nginx-proxy
IMG_NAME = "$(BASE_NAME)-img"
CTR_NAME = "$(BASE_NAME)-ctr"


proxy: etc/**/* Dockerfile .dockerignore
	docker build -t $(IMG_NAME) .

up:
	docker create -it -p 80:80 -p 443:443 --name $(CTR_NAME) $(IMG_NAME)
	docker start $(CTR_NAME)

down:
	docker stop $(CTR_NAME)
	docker rm $(CTR_NAME)

debug:
	docker exec -it $(CTR_NAME) /bin/sh
