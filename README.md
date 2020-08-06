# Dockerized NGINX Proxy

N. P. O'Donnell, 2020

Bare-bones dockerized reverse proxy. A starting point for more advanced proxy configurations.

## Features

* NGINX 1.19
* Small footprint (Alpine Linux)
* Support multiple sites
* HTTP/2 support
* Rewrites plain HTTP URLs to HTTPS
* Rewrites www.example.com to example.com

## Usage

**Check the Makefile for docker commands !**

Generate keys and certs:

```
make certs
```

Build the proxy image:

```
make proxy
```

Stand up / restart the proxy:

```
make up
```

Bring it down:

```
make down
```

## Testing

The boiler-plate sets the proxy to fetch [this](http://www.columbia.edu/~fdc/sample.html) web page, which is a good old-fashioned plain HTTP page. The following command can be used to check the operation of the proxy:

```
curl -k -i -H "Host: example.com" https://localhost | less
```

Should result in something like this: 

```
HTTP/2 200 
server: nginx/1.19.1
date: Fri, 31 Jul 2020 18:30:56 GMT
content-type: text/html
content-length: 29426
last-modified: Wed, 11 Dec 2019 12:46:44 GMT
accept-ranges: bytes
vary: Accept-Encoding,User-Agent
set-cookie: BIGipServer~CUIT~www.columbia.edu-80-pool=1311259520.20480.0000; expires=Sat, 01-Aug-2020 00:30:55 GMT; path=/; Httponly

<!DOCTYPE HTML>
<html lang="en">
<head>
<!-- THIS IS A COMMENT -->
<title>Sample Web Page</title>
...
```

Make sure HTTP to HTTPS redirects work too:

```
curl -k -i -L -H "Host: example.com" http://localhost | less
```

Should result in the same thing.

## Debugging

Debug (whilst up):

```
make debug
```
