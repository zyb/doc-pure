---
title: CDH5.7.2 Hadoop源码编译
date: 2016-12-10 15:50:49
updated:
categories:
	- 大数据
tags:
	- hadoop
---

## 一、环境

* Hadoop源码为Cloudera的5.7.2版本，这个版本源于Hadoop官方2.6.0版本
* JDK版本为1.7
* archlinux x64操作系统

## 二、CDH5 Hadoop源码下载

CDH是Cloudera开源组件的集合，Hadoop只是其中一个，Cloudera的源码并没有在github或其他类似的工具上维护，而是CDH的每个版本Cloudera都提供了源码下载包，都在 http://archive.cloudera.com/xxxx 中，'xxxx'表示具体的子路径。具体如下：

CDH3及以前的版本在 <http://archive.cloudera.com/cdh> 中
CDH4版本在 <http://archive.cloudera.com/cdh4> 中
CDH5版本在 <http://archive.cloudera.com/cdh5> 中

下载CDH5.7.2 Hadoop：

``` bash
$ wget http://archive.cloudera.com/cdh5/cdh/5/hadoop-2.6.0-cdh5.7.2-src.tar.gz
```

## 三、CDH5 Hadoop源码编译

CDH5.7.2版本的Hadoop依赖的protobuf是2.5.0版本，有两种方式：

1. 将系统的protobuf版本替换为2.5.0版本。
2. 如果当前开发系统还在用其它版本的protobuf，不想替换系统protobuf的，也可以设置到非系统环境目录下。通过github下载源码自行编译一个版本，或者下载别人编译好的2.5.0版本。但是如果是下载或者自行编译，假设protobuf的主目录是PROTOBUF_HOME，那么protoc的路径需要保证为'PROTOBUF_HOME/bin/protoc'，这个是后续用Cloudera的编译脚本执行是需要设置的，自行编译参考下面方法：

#### protobuf编译

protobuf需要自己编译，将下面%PROTOBUF_COMPILE_PATH%替换成你自己的protobuf所在的目录，：

``` bash
$ cd %PROTOBUF_COMPILE_PATH%
$ wget https://github.com/google/protobuf/releases/download/v2.5.0/protobuf-2.5.0.tar.gz
$ cd protobuf-2.5.0
$ ./configure --prefix=%PROTOBUF_COMPILE_PATH%/protobuf-2.5.0 # 设置prefix非常重要，否则在'make install'会替换系统中的protoc
$ make
$ make install
```

最终protoc生成位置为 %PROTOBUF_COMPILE_PATH%/protobuf-2.5.0/bin/protoc

#### Hadoop源码编译

> * Hadoop的编译除了jdk和protoc还依赖maven、ant。
> * 编译之前先修改./build.sh和./lib.sh中的第二行'set -xe'注释掉，这个是shell脚本设置的调试参数。
> * **重要提醒**：本次编译修改了lib.sh中的'MAVEN_FLAGS'，由于本机编译hadoop的hadoop-mapreduce-client-nativetask项目失败，因此需要去掉'-Pnative'参数。后续尝试成功之后再记录。

将下载的hadoop源码包拷贝到编译的路径下，我本地环境protobuf 2.5.0版的路径在跟'hadoop-2.6.0-cdh5.7.2'目录处于同一级目录，根据以下命令编译Hadoop：

``` bash
$ tar zxf hadoop-2.6.0-cdh5.7.2-src.tar.gz
$ cd hadoop-2.6.0-cdh5.7.2
$ cd cloudera
$ # ./build.sh --protobuf-home=../../protobuf-2.5.0 # 这种方式尝试失败，直接将本机的protobuf从3.0降到2.5.0，然后就不需要设置protobuf-home这个参数了
$ ./build.sh 
```

（未完待续...）

## 四、参考资料

无

> 对于hadoop-mapreduce-client-nativetask项目native模式下失败，在github上看到一个同样的问题<https://github.com/protegeproject/protege/issues/514>，回复了对方，等待对方回复，看看对方现在是否已经解决。
