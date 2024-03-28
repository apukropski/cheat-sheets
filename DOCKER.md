# 🐳 Docker Cheats

Run a container with python3.9 as base image:

```sh
docker run --rm -it python:3.9 /bin/bash
```

## 🏞️ Images

To list all images, run one of:

```sh
docker images
docker image list
```

### Download remote image

```sh
docker pull IMG-NAME
```

### Build

1. Create Dockerfile
2. Build image:
   ```sh
   docker build \
       -t ORG/IMAGE:TAG \
       -f DOCKERFILE-FPATH \
       CONTEXT-PATH
   ```

### Remove

Add `-f` to any of the commands for force removal, e.g, even if a container still uses the image

- Single:

  ```sh
  docker image rm IMG-NAME
  docker rmi IMG-NAME
  ```

- All
  ```sh
  docker rmi -f $(docker images -a -q)
  ```

## 📦 Container

### List

To list containers, one of:

```sh
docker container ls
docker ps -a
docker ps -a -s --format "table {{.ID}}\t{{.Images}}\t{{.Names}}\t{{.Status}}\t{{.Size}}"
```

### Create

```sh
docker run \
    -it \
    --rm \
    -p EXTERNAL:INTERNAL \
    --name CONTAINER-NAME \
    IMG-NAME
    CMD
```

Optional args:

- `-it`: interactive mode (leave with exit command)
- `--rm`: remove container when finished
- `--name`: set name of container
- `-u`: which user runs this ($(id -u) = current user ID). Use with caution!
- `--gpus`: which gpu(s) to use
  - `--gpus all` for all GPUs
- `--env-file FNAME`: for passing an env file
  - or `-e ENV_VAR=VALUE`
- `-v HOST:TARGET`: volume
  - e.g.: `-v $(pwd):/temp/`

### Close / Down

```sh
docker stop CONTAINER-ID
```

### Remove

```sh
docker container rm CONTAINER-ID
docker rm -f $(docker ps -a -q)     # all
```

## 🧼 Clean up docker

- Remove dangling images (named None / no tag):
  ```sh
  docker rmi $(docker images -q -f dangling=true)
  ```
- Remove unused images:
  ```sh
  docker image prune -a
  ```
- Remove volumes:
  ```sh
  docker volume prune -a
  ```
- Remove unused images and stopped containers:
  ```sh
  docker system prune -a
  ```

## 📜 Compose

### Create

```sh
docker-compose up --build --force-recreate -d;
```

- `-f` name of .yml
- `-d` detached mode

### Remove

```sh
docker-compose down --remove-orphans
```

- `-f` FNAME down to remove services defined in .yml file

Update parent images (in folder where docker-compose file lives):

```sh
cd COMPOSE-FPATH
docker-compose build --pull
```

### Compose File

For interactive mode, add in .yml to main service:

- `port`: host:container
- `stdin_open`: true (equivalent of `-i`)
- `tty`: true (equivalent of `-t`)
