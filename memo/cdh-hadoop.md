# cdh-hadoop手动安装记录

## 环境准备
0. 当前安装cdh版本为5.10.0版本；使用的EC2的定制linux，基于centos6，因此就是centos6版本；java8环境；cdh依赖python环境，python2.6以上，不支持python3
1. 包含cloudera manager组件的压缩包，下载地址：<http://archive.cloudera.com/cm5/repo-as-tarball/5.10.1/cm5.10.1-centos6.tar.gz>
2. 下载cloudera的parcel，Parcels是Cloudera Manager用来升级软件的打包格式，由于parcel比较大，提前下载下来，安装时就不会边下载边安装了，：<http://archive.cloudera.com/cdh5/parcels/5.10.1/CDH-5.10.1-1.cdh5.10.1.p0.10-el6.parcel> <http://archive.cloudera.com/cdh5/parcels/5.10.1/CDH-5.10.1-1.cdh5.10.1.p0.10-el6.parcel.sha1> <http://archive.cloudera.com/cdh5/parcels/5.10.1/manifest.json>
3. 配置所有节点关闭防火墙iptables和SELinux
4. 修改所有部署机器的hosts，使所有机器互相之间都可以通过hostname可以连通

## 安装
1. 解压cdh5.10.1-centos6.tar.gz，在“cm/5.10.0/RPMS/x86_64”目录下是所有的安装包，由于当前使用java8，不再安装java相关包
``` shell
cloudera-manager-agent-5.10.1-1.cm5101.p0.6.el6.x86_64.rpm
cloudera-manager-daemons-5.10.1-1.cm5101.p0.6.el6.x86_64.rpm
cloudera-manager-server-5.10.1-1.cm5101.p0.6.el6.x86_64.rpm
cloudera-manager-server-db-2-5.10.1-1.cm5101.p0.6.el6.x86_64.rpm
enterprise-debuginfo-5.10.1-1.cm5101.p0.6.el6.x86_64.rpm
jdk-6u31-linux-amd64.rpm
oracle-j2sdk1.7-1.7.0+update67-1.x86_64.rpm
```
2. 在server节点上安装server和agent包：
``` shell
> sudo yum localinstall --nogpgcheck cloudera-manager-daemons-*.rpm cloudera-manager-server-*.rpm cloudera-manager-agent-*.rpm
```
3. 在所有的agent节点上安装agent包：
``` shell
> sudo yum localinstall --nogpgcheck cloudera-manager-daemons-*.rpm cloudera-manager-agent-*.rpm
```
4. cdh依赖database存储配置，当前使用mysql，所有节点都需要安装mysql-connector-java
``` shell
> sudo yum install mysql-connector-java.noarch
```
5. 将parcel相关文件放置到server节点的/opt/cloudera/parcel-repo/目录下，注意CDH.xxx.parcel.sha1这个文件名一定要把最后的1去掉
``` shell
> sudo cp manifest.json /opt/cloudera/parcel-repo/
> sudo cp CDH-5.10.1-1.cdh5.10.1.p0.10-el6.parcel /opt/cloudera/parcel-repo/
> sudo mv CDH-5.10.1-1.cdh5.10.1.p0.10-el6.parcel.sha1 CDH-5.10.1-1.cdh5.10.1.p0.10-el6.parcel.sha && sudo cp CDH-5.10.1-1.cdh5.10.1.p0.10-el6.parcel.sha /opt/cloudera/parcel-repo/
```

## 启动
1. 安装和配置mysql，cdh启动依赖db，具体参考
<https://www.cloudera.com/documentation/enterprise/latest/topics/cm_ig_installing_configuring_dbs.html>
<https://www.cloudera.com/documentation/enterprise/latest/topics/cm_ig_mysql.html#cmig_topic_5_5_3>
``` shell
# 安装mysql，参考上面链接中的配置mysql:/etc/my.cnf
> sudo yum install mysql-server

# 配置mysql开机启动
> sudo chkconfig --list mysqld

# 启动mysql
> sudo service mysqld start

# 首次启动设置mysql
> sudo /usr/bin/mysql_secure_installation

# mysql中增加cdh访问的用户，并且将这个用户配置为server主机有访问这个库的权限，并且用户要有insert、delete、update、select、create、drop、alter权限
# 然后用scm_prepare_database.sh脚本配置scm数据库，-uxxx和-pxxx分别用于在mysql中创建库表的用户和密码（xxx替换对应的用户名和密码），cdh-user和cdh-pw分别表示cloudera manager访问scm库使用的用户和密码
> sudo /usr/share/cmf/schema/scm_prepare_database.sh mysql -uxxx -pxxx scm cdh-user cdh-pw
```
2. 启动cloudera manager server，只需要启动server，agent在后续页面配置会被启动
``` shell
> sudo service cloudera-scm-server start
```
3. server启动成功之后，打开http://localhost:7180一步步按照提示部署配置，最终就会进入cloudera manager的管理页面，配置中有以下注意：
> * 进行配置时，配置会提示需要root账户或者无密码的sudo权限账户
> * 在EC2上用aws的linux时，parcel安装时会检到lsb_release文件，但是cloudera manager是将包含/etc/lsb_release的linux识别为ubuntu，由于aws的linux是基于centos6的，安装部署也是用centos6的包进行部署的，而cloudera manager是通过/etc/redhat_release识别为redhat系的linux，并且是通过redhat_release文件中包含“CentOS Linux release 6”字符串识别为centos6，因此创建/etc/redhat_release文件并且内容为“LSB_VERSION=CentOS Linux release 6”，不需要删除之前的lsb_release文件。
> * 如果配置过程中使用了Activity Monitor服务，会需要配置一个数据库，这个数据库需要手动在数据库中创建，并且对于配置的用户需要有insert、delete、update、select、create、drop、alter权限

## 运行MR
1. 可以先运行官方的example试试
``` shell
> hadoop jar /opt/cloudera/parcels/CDH/lib/hadoop-mapreduce/hadoop-mapreduce-examples.jar wordcount input output
```
2. 运行个人开发的MR可能遇到的问题及解决方案
> * 加入第三方依赖，MR可以通过ToolRunner运行时，可以通过使用‘-libjars’参数设置以来的lib，由于是ToolRunner的参数要放到自己运行的main需要参数的前边
> * 对于出现的包冲突问题，一些对包版本不是很敏感或者说版本不是很重要的，开发使用的包最好以hadoop为主，对于要以开发环境为主的包，可以通过配置下面两个参数“-Dmapreduce.job.user.classpath.first=true -Dmapreduce.job.jar=xxx.jar”，其中‘xxx.jar’为包路径，这里也可以是多个包。


## 参考信息
<http://www.aboutyun.com/thread-18107-1-1.html>
<http://www.jianshu.com/p/57179e03795f>
cdh5卸载参考: <https://niksammy.wordpress.com/2014/04/21/uninstalling-cdh5-cluster/>
