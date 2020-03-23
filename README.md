## 背景
利用 docker-compose 快速部署一套Java开发环境（包含Nginx/Tomcat8/Mysql8/Redis5 等软件）。

## 依赖

- [Git](https://git-scm.com/downloads)
- [Docker](https://www.docker.com/products/docker/)
- [Docker-Compose](https://docs.docker.com/compose/install/#install-compose)

## 快速部署步骤

1. `$ git clone https://github.com/hqlsoftware/javaweb-dev-docker-compose.git`
2. `$ cd javaweb-dev-docker-compose`
3. `$ vi init.cnf #配置项目参数`
4. `$ sh init.sh`
5. 测试访问（Nginx/Tomcat/Mysql/Redis）是否可以使用

运维命令：

```
$ docker-compose help   # docker-compose 命令帮助
$ docker-compose up     # 创建并启动 docker 编排服务
$ docker-compose down   # 停止并移除 docker 编排服务 (更改配置文件时建议使用)
$ docker-compose exec javaweb-dev-docker-compose bash # ssh 登入 javaweb 容器
```

## 数据库信息

- `hostname: mysql`

此处的数据库连接地址 `hostname` 值为 `mysql` ，容器中会在自己的 `/etc/hosts` 中添加一条 `1xx.xx.xx.xx mysql` 的 host，这会将 `http://mysql` 这个地址指向 `mysql` 容器的实际内网地址，等效于常见的 `http://localhost` 。

## 数据持久化

容器内的数据会随着容器的销毁而丢失，所以需要配置 `docker-compose.yml` 文件将以下目录同步到你的物理机目录进行持久化：

- `/var/lib/mysql` MySQL 的文件存放目录，必须挂载，否则销毁容器后数据丢失。
- `/usr/local/tomcat/logs` Tomcat 的日志目录，挂载后查看日志无须进入容器内部。
- `/data` Redis数据存储目录。

## 项目部署

数据库信息，暴露端口等信息都在 `docker-compose.yml` 中配置，一切调试完成后可在启动命令后添加 `-d` 参数，让其后台启动，此时如果想实时查看启动日志可以使用 `docker-compose logs -f` 进行查看。

```
# 后台启动运行
$ docker-compose up -d

# 跟踪查看启动日志
$ docker-compose logs -f
```

## 版本信息

- **JAVA** ：`1.8`
- **MySQL** ：`8`
- **Tomcat** ：`8.5.35`
- **Redis** ：`5.0.2`

版本信息可在 `Dockerfile` 中进行修改，修改 `Dockerfile` 后需要将 `docker-compose` 中的构建方式改为构建本地镜像：

```
# 免构建镜像
# image: redis:5.0.2
# 构建本地镜像
  build: ./redis
```

修改完成后启动时需要重新构建镜像：

```
$ docker-compose up --build
```

## 目录结构

```
javaweb-dev-docker-compose/
├── docker-compose.yml  # docker-compose 配置文件
├── mysql
│   ├── conf  # 容器配置挂载目录
│   ├── data  # 容器数据挂载目录
│   └── Dockerfile   # MySQL 构建文件
├── README.md
├── redis
│   ├── conf   # 容器配置挂载目录
│   ├── data   # 容器数据挂载目录
│   └── Dockerfile
└── tomcat
    ├── conf    # 容器配置挂载目录
    ├── Dockerfile   # Tomcat 构建文件
    ├── logs   # 容器日志挂载目录
    └── webapps
        └── ROOT   # tomcat默认ROOT项目
……………
```
