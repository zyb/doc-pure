---
title: Jstorm接口开发之HelloWorld
date: 2016-12-12 11:19:02
updated:
categories:
	- 大数据
tags:
	- jstorm
---

## 环境

* Jstorm版本2.1.1
* JDK版本1.7
* archlinux x64操作系统

## Jstorm概述

从应用的角度来说，JStorm它是一种分布式的应用；从系统层面来说，它又类似于MapReduce这样的调度系统；而从数据方面来说，它又 是一种基于流水数据的实时处理解决方案。如今，DT时代的当下，用户和企业也不仅仅只满足于离线数据，对于数据的实时性要求也越来越高了。

在早期，Storm和JStorm未问世之前，业界有很多实时计算系统，可谓百家争鸣，自Storm和JStorm出世之后，基本这两者占据主要地位，原因如下：

* 易开发：接口简单，上手容易，只需要按照Spout，Bolt以及Topology的编程规范即可开发一个扩展性良好的应用，底层的细节我们可以不用去深究其原因。
* 扩展性：可线性扩展性能。
* 容错：当Worker异常或挂起，会自动分配新的Worker去工作。
* 数据精准：其包含Ack机制，规避了数据丢失的风险。使用事物机制，提高数据精度。

JStorm处理数据的方式流程是基于流式处理，因此，我们会用它做以下处理：

* 日志分析：从收集的日志当中，统计出特定的数据结果，并将统计后的结果持久化到外界存储介质中，如：DB。当下，实时统计主流使用JStorm和Storm。
* 消息转移：将接受的消息进行Filter后，定向的存储到另外的消息中间件中。

## 基本术语

Storm通过一系列基本元素实现实时计算的目标，其中包括了Topology、Stream、Spout、Bolt、Tuple、worker、task、slot。

### Stream

在JStorm当中，有对Stream的抽象，它是一个不间断的无界的连续Tuple，而JStorm在建模事件流时，把流中的事件抽象为Tuple。

![](http://images2015.cnblogs.com/blog/666745/201509/666745-20150915135843351-643602897.png)

### Spout和Bolt

在JStorm中，它认为每个Stream都有一个Stream的来源，即Tuple的源头，所以它将这个源头抽象为Spout，而Spout可能是一个消息中间件，如：MQ，Kafka等。并不断的发出消息，也可能是从某个队列中不断读取队列的元数据。

在有了Spout后，接下来如何去处理相关内容，以类似的思想，将JStorm的处理过程抽象为Bolt，Bolt可以消费任意数量的输入流， 只要将流方向导到该Bolt即可，同时，它也可以发送新的流给其他的Bolt使用，因而，我们只需要开启特定的Spout，将Spout流出的Tuple 导向特定的Bolt，然后Bolt对导入的流做处理后再导向其它的Bolt等。

那么，通过上述描述，其实，我们可以用一个形象的比喻来理解这个流程。我们可以认为Spout就是一个个的水龙头，并且每个水龙头中的水是不同的，我们想要消费那种水就去开启对应的水龙头，然后使用管道将水龙头中的水导向一个水处理器，即Bolt，水处理器处理完后会再使用管道导向到另外的处理器或者落地到存储介质。

![](http://images2015.cnblogs.com/blog/666745/201509/666745-20150915140959179-1408063851.png)

### Topology

实时计算任务需要打包成Topology提交，计算任务Topology是由不同的Spout和Bolt通过Stream连接起来的DAG图，它是JStorm中最高层次的一个抽象概念，一个Topology即为一个数据流转换图，图中的每个节点是一个 Spout或者Bolt，当Spout或Bolt发送Tuple到流时，它就发送Tuple到每个订阅了该流的Bolt上。

![](http://images2015.cnblogs.com/blog/666745/201509/666745-20150915141401726-976011955.png)

### Tuple

JStorm当中将Stream中数据抽象为了Tuple，一个Tuple就是一个Value List，List值的每个Value都有一个Name，并且该Value可以是基本类型，字符类型，字节数组等，当然也可以是其它可序列化的类型。 Topology的每个节点都要说明它所发射出的Tuple的字段的Name，其它节点只需要订阅该Name就可以接收处理相应的内容。

### Worker和Task

Work和Task在JStorm中的职责是一个执行单元，一个Worker表示一个进程，一个Task表示一个线程，一个Worker可以运行多个Task，一个Worker中的Task必须属于同一个Topology。

Worker可以通过setNumWorkers(int workers)方法来设置对应的数目，表示这个Topology运行在多个JVM（PS：一个JVM为一个进程，即一个Worker）；另外 setSpout(String id, IRichSpout spout, Number parallelism_hint)和setBolt(String id, IRichBolt bolt,Number parallelism_hint)方法中的参数parallelism_hint代表这样一个Spout或Bolt有多少个实例，即对应多少个线程，一 个实例对应一个线程。

### Slot

在JStorm当中，Slot的类型分为四种，他们分别是：CPU，Memory，Disk，Port；与Storm有所区别（Storm局限 于Port）。一个Supervisor可以提供的对象有：CPU Slot、Memory Slot、Disk Slot以及Port Slot。

* 在JStorm中，一个Worker消耗一个Port Slot，默认一个Task会消耗一个CPU Slot和一个Memory Slot。
* 在Task执行较多的任务时，可以申请更多的CPU Slot。
* 在Task需要更多的内存时，可以申请更多的额Memory Slot。
* 在Task磁盘IO较多时，可以申请Disk Slot。

## Jstorm架构

从设计层面来说，JStorm是一个典型的调度系统。架构如下：

![](/uploads/jstorm-framework.png)

* ZooKeeper：系统的协调者
* Nimbus：调度器
* Supervisor：Worker的代理角色，负责Kill掉Worker和运行Worker
* Worker：一个JVM进程，Task的容器
* Task：一个线程，任务的执行者

## Jstorm接口开发——Topology

Topology的开发基本也有一些套路，根据官方的一些Example，总结了一个Topology基类：

``` java
  public static abstract class SelfDefTopologyImp {

    protected Map conf = new HashMap<Object, Object>();

    // TopologyBuilder设置接口，不同的Topology实现这个接口
    protected abstract void SetBuilder(TopologyBuilder builder, Map conf);

    // 本地模式启动：
    // 1、通过配置文件获取Toplogy Name
    // 2、通过setBuild抽象接口设置TopologyBuilder
    // 3、以本地模式启动任务
    // 4、本地调试模式根据调试时间，最终关闭本地模式
    protected void SetLocalTopology() throws Exception {
      String tname = (String) conf.get(Config.TOPOLOGY_NAME);
      if (tname == null) {
        new IllegalArgumentException("Toplogy Name is null");
      }

      TopologyBuilder builder = new TopologyBuilder();
      SetBuilder(builder, conf);

      LocalCluster cluster = new LocalCluster();
      cluster.submitTopology(tname, conf, builder.createTopology());

      Thread.sleep(60000);
      cluster.killTopology(tname);
      cluster.shutdown();
    }

    // 集群模式启动：
    // 1、通过配置文件获取Toplogy Name
    // 2、通过setBuild抽象接口设置TopologyBuilder
    // 3、向集群提交任务
    protected void SetRemoteTopology() throws AlreadyAliveException,
        InvalidTopologyException {
      String tname = (String) conf.get(Config.TOPOLOGY_NAME);
      if (tname == null) {
        new IllegalArgumentException("Toplogy Name is null");
      }

      TopologyBuilder builder = new TopologyBuilder();
      SetBuilder(builder, conf);

      conf.put(Config.STORM_CLUSTER_MODE, "distributed");

      StormSubmitter.submitTopology(tname, conf, builder.createTopology());
    }

    protected void LoadConf(String arg) {
      if (arg.endsWith("yaml")) {
        conf = LoadConf.LoadYaml(arg);
      } else {
        conf = LoadConf.LoadProperty(arg);
      }
    }

    // 根据配置文件判断启动模式是‘本地模式’或‘集群模式’
    protected boolean local_mode(Map conf) {
      String mode = (String) conf.get(Config.STORM_CLUSTER_MODE);
      if (mode != null) {
        if (mode.equals("local")) {
          return true;
        }
      }

      return false;
    }

    // 主入口：1、加载配置文件；2、根据配置文件中‘本地模式’或‘集群模式’的配置，分别启动
    public void run(String cfile) throws Exception {
      if (StringUtils.isBlank(cfile)) throw new IllegalArgumentException("params invalid.");

      LoadConf(cfile);
      if (local_mode(conf)) {
        SetLocalTopology();
      } else {
        SetRemoteTopology();
      }
    }
  }
```

> * 最主要的就是SetBuilder()这个接口，直接通过这个接口配置TopologyBuilder即可。
> * SelfDefTopologyImp主要封装了配置读取，本地模式和集群模式启动，其他细节参考代码。

HelloTopology类继承SelfDefTopologyImp，具体实现如下：

``` java
  public static class HelloTopology extends SelfDefTopologyImp {
    public void SetBuilder(TopologyBuilder builder, Map conf) {

      // 从配置文件中读取spout和bolt的并行数
      int spout_Parallelism_hint = JStormUtils.parseInt(conf.get("topology.spout.parallel"), 1);
      int bolt_Parallelism_hint = JStormUtils.parseInt(conf.get("topology.bolt.parallel"), 1);

      // 设置spout和bolt的名称
      String spoutName = HelloSpout.class.getSimpleName();
      String boltName = HelloBolt.class.getSimpleName();

      // 设置spout和bolt，其中shuffleGrouping指明了HelloBolt接收HelloSpout的数据
      // 这里的设置最终就是Topology的DAG图
      builder.setSpout(spoutName, new HelloSpout(), spout_Parallelism_hint);
      builder.setBolt(boltName, new HelloBolt(), bolt_Parallelism_hint).shuffleGrouping(spoutName);
    }
  }
```

## Jstorm接口开发——Spout

HelloSpout实现的功能是：每秒生成一个随机数，并向后传递。

``` java
  public static class HelloSpout extends BaseRichSpout {
    private SpoutOutputCollector collector;
    private static Random rand;

    public void open(Map conf, TopologyContext context, SpoutOutputCollector collector) {
      this.collector = collector;
      this.rand = new Random();
    }

    public void nextTuple() {
      int r = rand.nextInt(9999);
      collector.emit(new Values(r));
      try {
        Thread.sleep(1000);
      } catch (InterruptedException e) {
        e.printStackTrace();
      }
    }

    public void declareOutputFields(OutputFieldsDeclarer declarer) {
      declarer.declare(new Fields("value"));
    }
  }
```

## Jstorm接口开发——Bolt

``` java
  public static class HelloBolt extends BaseBasicBolt {

    public void prepare(Map stormConf, TopologyContext context) {
      super.prepare(stormConf, context);
    }

    public void execute(Tuple input, BasicOutputCollector collector) {
      int n = input.getIntegerByField("value");
      System.out.println();
      System.out.println("===========================");
      System.out.println("value: " + n);
      System.out.println("===========================");
      System.out.println();
    }

    public void declareOutputFields(OutputFieldsDeclarer declarer) {
    }
  }
```

## Jstorm运行接口开发——主函数

``` java
public class JstormHelloWorld {
  public static void main(String[] args) throws Exception {
    if (args.length == 0) {
      System.err.println("Please input configuration file");
      System.exit(1);
    }

    (new HelloTopology()).run(args[0]);
  }
}
```

## Jstorm任务配置

配置文件如下：

``` yaml
# 集群模式还是本地模式
storm.cluster.mode: "local"
#storm.cluster.mode: "distributed"

# topology名称配置
topology.name: "JstormHelloWorld"

# spout和bolt的并行数配置
topology.spout.parallel: 1
topology.bolt.parallel: 1
```

## Jstorm任务提交

本地运行命令如下，conf/jstormHelloWorld.yaml是配置文件。

``` bash
$ java -cp JstormHelloWorld-1.0.0-jar-with-dependencies.jar io.github.zyb.jstorm.JstormHelloWorld conf/jstormHelloWorld.yaml
```

## 注意事项

* Jstorm提交的Topology的名称中不能包含空格，准确来说名称应符合的正则表达式为"[a-zA-Z0-9-_.]+"

* **重要提醒**：Jstorm开发中pom.xml配置依赖jstorm-core，在集群模式下需要这个包的配置是provided，但是在本地运行模式下又需要是非provided，也就是本地模式要配置如下，集群模式需要去掉注视：

``` xml
    <dependency>
      <groupId>com.alibaba.jstorm</groupId>
      <artifactId>jstorm-core</artifactId>
      <version>2.1.1</version>
      <!-- <scope>provided</scope> -->
    </dependency>
```

## 参考资料

[JStorm－介绍](https://yq.aliyun.com/articles/34083) **强烈推荐，入门先看** 本文多出引用来自于此
[Jstorm Example](https://github.com/alibaba/jstorm/blob/2.1.1/example/sequence-split-merge/src/main/java/com/alipay/dw/jstorm/example/sequence) 本文示例部分代码参考于此
[Storm之Hello World：单词统计](http://mojijs.com/2016/10/219731/index.html) 本文示例部分代码参考于此
[JStorm - Hello Word](http://blog.csdn.net/szzhaom/article/details/41792023) 本文示例部分代码参考于此
[JStorm介绍](http://www.voidcn.com/blog/wwwxxdddx/article/p-4881831.html) **强烈推荐，入门先看**
[JStorm之Nimbus简介](http://www.voidcn.com/blog/wwwxxdddx/article/p-4881832.html) **入门先看**
[JStorm之Supervisor简介](http://www.voidcn.com/blog/wwwxxdddx/article/p-4881833.html) **入门先看**
[Jstorm官方Example](http://jstorm.io/quickstart_cn/Example.html)官网示例，基本没怎么参考，无力吐槽...
[Jstorm Github Wiki](https://github.com/alibaba/jstorm/wiki/JStorm-Chinese-Documentation)
[Jstorm基本概念](https://github.com/alibaba/jstorm/wiki/%E5%9F%BA%E6%9C%AC%E6%A6%82%E5%BF%B5)

## 拓展阅读

[双11媒体大屏背后的数据技术与产品 ](https://yq.aliyun.com/articles/66098?spm=5176.100240.searchblog.22.FjBOiE)
[JStorm，让大规模流处理成为可能 ](https://yq.aliyun.com/articles/62693?spm=5176.100240.searchblog.36.FjBOiE)