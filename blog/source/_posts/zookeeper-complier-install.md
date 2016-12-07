---
title: Zookeeper编译和部署
date: 2016-12-06 20:26:13
updated: 
categories: 
	- 大数据
tags: 
	- zookeeper 

---
### 背景

* 当前zookeeper使用的是git上3.4.9这个tag，是当前稳定版本
* jdk为1.7版本
* archlinux x64 操作系统

### Zookeeper源码编译

#### 源码下载

从github上下载zookeeper源码

``` bash
$ git clone https://github.com/apache/zookeeper.git
```

#### 源码编译

zookeeper使用ant管理项目，因此编译zookeeper使用ant工具，使用以下命令，最终在build文件夹下生成'zookeeper-<version>.tar.gz'，这个包就是最后zookeeper编译完成生成的包，如果只使用'ant package'命令，则不会生成.tar.gz这个包，只会生成'zookeeper-<version>'这个目录，这个目录包含了所有的

``` bash
$ cd zookeeper
$ ant package tar

```
如果有需要用eclipse打开，可以通过以下命令生成eclipse的project，在eclipse中通过导入’已存在的eclipse项目‘，将zookeeper导入到eclipse中

``` bash
$ ant eclipse
```

### Zookeeper部署

1. 
