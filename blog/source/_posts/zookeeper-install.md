---
title: Zookeeper编译、部署、配置
date: 2016-12-06 20:26:13
updated: 
categories: 
	- 大数据
tags: 
	- zookeeper 

---
## 一、背景

* 当前zookeeper使用的是git上3.4.9这个tag，是当前稳定版本
* jdk为1.7版本
* archlinux x64 操作系统

## 二、Zookeeper源码编译

### 源码下载

从github上下载zookeeper源码

``` bash
$ git clone https://github.com/apache/zookeeper.git
```

### 源码编译

zookeeper使用ant管理项目，因此编译zookeeper使用ant工具，使用下面命令，最终在build文件夹下生成'zookeeper-{version}.tar.gz'，这个包就是最后zookeeper编译完成生成的包，如果只使用'ant package'命令，则不会生成.tar.gz这个包，只会生成'zookeeper-{version}'这个目录，这个目录就是编译好的zookeeper

进入zookeeper目录，切换git分支到稳定版本分支，当前分支为3.4.9。

``` bash
$ cd zookeeper
$ git checkout release-3.4.9
$ ant package tar

```
如果有需要用eclipse打开，可以使用下面命令生成eclipse的project，在eclipse中通过导入’已存在的eclipse项目‘，将zookeeper导入到eclipse中

``` bash
$ cd zookeeper
$ ant eclipse
```

## 三、Zookeeper部署

将编译后的zookeeper目录或者.tar.gz包拷贝到将要部署的目录，即完成部署。多机（多进程）部署，就分别拷贝将要部署的目录即可。（上一步编译的.tar.gz包，如果不自己编译，可以直接从官网下载。）

## Zookeeper配置

以下分别针对单实例和多机配置说明。

zookeeper主要的配置文件为conf目录下的zoo.conf。

zookeeper在linux下的启动脚本为bin目录下的zkServer.sh，zookeeper相关的环境变量脚本为bin目录下的zkEnv.sh，zkServer.sh和zkEnv.sh脚本一般不需要修改，用于启动服务，主要修改zoo.conf。

### zookeeper单实例配置

zoo.conf配置非常简单。单实例配置如下：

``` configure
tickTime=2000 
dataDir=./zoodata
clientPort=2181
```
> *tickTime*: 这个时间作为zookeeper服务端与客户端之间维持心跳的时间间隔，时间单位为：ms（毫秒），每隔tickTime时间就会发送一个心跳。
> *dataDir*: 这个是zookeeper保存数据的目录，默认情况下，zookeeper也将写数据的日志保存在这个目录下。
> *clientPort*: 这个作为客户端连接zookeeper服务器的端口。

### zookeeper集群配置

对于集群配置，只需要在单实例的基础上增加几个配置就可以了，如下：

``` configure
initLimit=10
syncLimit=5
server.1=192.168.0.1:2888:3888
server.2=192.168.0.2:2888:3888
```

> *initLimit*: 这个配置项是用来配置 Zookeeper 接受客户端（这里所说的客户端不是用户连接 Zookeeper 服务器的客户端，而是 Zookeeper 服务器集群中连接到 Leader 的 Follower 服务器）初始化连接时最长能忍受多少个心跳时间间隔数。当已经超过 10 个心跳的时间（也就是 tickTime）长度后 Zookeeper 服务器还没有收到客户端的返回信息，那么表明这个客户端连接失败。总的时间长度就是 10x2000=20 秒
> *syncLimit*: 这个配置项标识 Leader 与 Follower 之间发送消息，请求和应答时间长度，最长不能超过多少个 tickTime 的时间长度，总的时间长度就是 5x2000=10 秒
> *server.N=A:P1:P2*, 其中 N 是一个数字，表示这个是第几号服务器；A 是这个服务器的 ip 地址；P1 表示的是这个服务器与集群中的 Leader 服务器交换信息的端口；P2 表示的是万一集群中的 Leader 服务器挂了，需要一个端口来重新进行选举，选出一个新的 Leader，而这个端口就是用来执行选举时服务器相互通信的端口。如果是伪集群的配置方式，由于 A 都是一样，所以不同的 Zookeeper 实例通信端口号不能一样，所以要给它们分配不同的端口号。
> 集群配置最重要的一点：对于集群配置，除了修改zoo.cfg外，还需要在dataDir目录下配置一个名字为'myid'的文件，这个文件里的值就是上个配置A的值，zookeeper 启动时会读取这个文件，拿到里面的数据与 zoo.cfg 里面的配置信息比较从而判断到底是那个server。

## 四、Zookeeper启动

zookeeper命令：bin/zkServer.sh {start|start-foreground|stop|restart|status|upgrade|print-cmd}

启动zookeeper：

``` bash
bin/zkServer.sh start
```

启动后查看zookeeper是否启动成功：

``` bash
bin/zkServer.sh status
```

停止zookeeper：
``` bash
bin/zkServer.sh stop
```

## 五、参考资料
[Apache Zookeeper GettingStart](https://zookeeper.apache.org/doc/trunk/zookeeperStarted.html)
[分布式服务框架Zookeeper(IBM DevelopWorks中国)](https://www.ibm.com/developerworks/cn/opensource/os-cn-zookeeper/)

（完结）
