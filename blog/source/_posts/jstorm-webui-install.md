---
title: Jstorm Web UI 安装部署
date: 2016-12-09 15:56:15
updated:
categories:
	- 大数据
tags:
	- jstorm
---

## 一、环境

* Jstorm为当前稳定版本2.1.1
* JDK为1.7
* archlinux x64 操作系统
* Jstorm服务的安装部署参考：[Jstorm从源码编译及配置部署](/2016/12/07-jstorm-install.html)

## 二、概述

WebUI 的安装部署和JStorm 是完全独立的。而且并不要求WebUI的机器必须是在Jstorm机器中。一个web UI 可以管理多个集群，只需在WebUI的配置文件中，增加新集群的配置即可。

**注意**：WebUI使用的版本必须和集群中Jstorm最高的版本一致。

## 三、Jstorm WebUI配置

这个在Jstorm WebUI相关组件安装前有必要先说明一下如何配置。

Jstorm WebUI的配置文件目录在用户的home目录下: ~/.jstorm/storm.yaml，从Jstorm WebUI的源码上看，这个配置是代码中直接写死的，无法配置。（也是无语了...）

官方上做法，这个配置是将nimbus服务上的conf/storm.yaml配置拷贝到~/.jstorm/storm.yaml。这样就完成了Jstorm WebUI单Jstorm集群的配置了。

如果是多机群的话在~/.jstorm/storm.yaml配置中追加其他集群配置信息即可，追加信息如下：

``` configure
# UI MultiCluster
# Following is an example of multicluster UI configuration
 ui.clusters:
     - {
         name: "zjstorm",
         zkRoot: "/zjstorm",
         zkServers:
             [ "127.0.0.1"],
         zkPort: 2181,
       }
     - {
         name: "jstorm.o",
         zkRoot: "/jstorm.other",
         zkServers:
             ["zk.test1.com", "zk.test2.com", "zk.test3.com"],
         zkPort: 2181,
       }
```

> **name**: 是集群的名称，**保证不能重复**。
> **zkRoot**: 对应$JSTORM_HOME/conf/storm.yaml 中'storm.zookeeper.root'配置。
> **zkServers**: Zookeeper集群机器列表。
> **zkPort**: Zookeeper集群端口。

**注意**：这里需要注意的一点是，多机群配置'ui.clusters'下面的集群配置不包含配置文件中原本的集群，之包含后续加入的集群。这个尝试配置，最终在WebUI界面上也可以看到。

以上都是官方的给出的做法，个人实践了一种方式：配置文件中只配置多机群相关的配置，比如现在只有一个Jstorm集群，~/.jstorm/storm.yaml配置文件中只需要写入下列信息即可：

``` configure
# UI MultiCluster
 ui.clusters:
     - {
         name: "z.jstorm",
         zkRoot: "/zjstorm",
         zkServers:
             [ "127.0.0.1"],
         zkPort: 2181,
       }
```

其实这个也不难搞明白，其实Jstorm WebUI也只需要这些配置信息。

## 四、Jstorm WebUI安装

Jstorm WebUI依赖Tomcat，因此首先安装Tomcat，官方文档说明必须用7.x版本，没有说明为什么，当前7.x的稳定版本为7.0.73。

Tomcat下载：

``` bash
$ wget http://mirrors.hust.edu.cn/apache/tomcat/tomcat-7/v7.0.73/bin/apache-tomcat-7.0.73.tar.gz
```

2.1.1版本的Jstorm WebUI依赖的jstorm-ui-2.1.1.war获取：

> * 从官网下载，官网下载的Jstorm的zip包里包含了jstorm-ui-2.1.1.war。
> * 如果是跟据 [Jstorm从源码编译及配置部署](/2016/12/07-jstorm-install.html) 自己编译的Jstorm，在编译后的目录和zip包中就包含了jstorm-ui-2.1.1.war

Jstorm WebUI安装，将Tomcat下载的压缩包拷贝到部署目录，然后执行以下命令：

``` bash
$ tar zxf apache-tomcat-7.0.73.tar.gz
$ cd apache-tomcat-7.0.73/webapps
$ cp $JSTORM_HOME/jstorm-ui-2.1.1.war ./
$ mv ROOT ROOT.old
$ ln -s jstorm-ui-2.1.1 ROOT
$ cd ..
```

执行到这里Jstorm WebUI就安装完成了，配置信息根据上一节提到的配置进行配置。

## 五、启动Jstorm WebUI

Jstorm WebUI的启动就是启动Tomcat，到Tomcat的主目录下执行下面命令：

``` bash
$ ./bin/startup.sh
```

如果是本机部署的Tomcat，打开 <http://127.0.0.1:8080> 就可以看到Jstorm的WebUI界面，不得不说这个界面比较丑，也比较简单，只有一些基本能力。

至于Jstorm WebUI的服务关闭等其他功能，这都是Tomcat的操作，自行Google。

## 六、参考资料

[Jstorm QuickStart Deploy WebUI](http://jstorm.io/quickstart_cn/Deploy/WebUI.html)