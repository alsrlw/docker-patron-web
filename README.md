# Docker image for Simply-E Patron Web Interface

## Example docker-compose.yml

```
version: '2'
services:
  patron-web:
    container_name: patron-web
    image: lyrasis/patron-web:latest
    environment:
      CONFIG: /config
    volumes:
      - ./config:/config
    ports:
      - 3000:3000
```

## Notes

Any environment varibles passed into the container will be passed into node, 
so you can setup a config file or registry server to that the app will use.

## ENV

### UID
The UID that the node process will be started with in the container. Defaults to 990.

### GID
The GID that the node process will be started with in the contatiner. Defaults to 990.
