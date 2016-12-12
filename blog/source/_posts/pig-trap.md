---
title: apache Pig踩坑之旅（以及pig特性描述）
date: 2016-12-11 16:48:57
updated:
categories:
	- 大数据
tags:
	- pig
---

## 环境

* pig使用版本是0.16.0版本
* jdk版本1.7
* archlinux x64操作系统

## Pig坑

### 1. 在local模式同时执行多个pig脚本

**问题描述**：如果在以local模式同时执行多个pig脚本，就部分脚本就有可能遇到类似下面的错误信息：

``` java
org.apache.hadoop.util.DiskChecker$DiskErrorException: Could not find output/spill0.out in any of the configured local directories
        at org.apache.hadoop.fs.LocalDirAllocator$AllocatorPerContext.getLocalPathToRead(LocalDirAllocator.java:429)
        at org.apache.hadoop.fs.LocalDirAllocator.getLocalPathToRead(LocalDirAllocator.java:160)
        at org.apache.hadoop.mapred.MapOutputFile.getSpillFile(MapOutputFile.java:107)
        at org.apache.hadoop.mapred.MapTask$MapOutputBuffer.mergeParts(MapTask.java:1614)
        at org.apache.hadoop.mapred.MapTask$MapOutputBuffer.flush(MapTask.java:1323)
        at org.apache.hadoop.mapred.MapTask$NewOutputCollector.close(MapTask.java:699)
        at org.apache.hadoop.mapred.MapTask.runNewMapper(MapTask.java:766)
        at org.apache.hadoop.mapred.MapTask.run(MapTask.java:370)
        at org.apache.hadoop.mapred.LocalJobRunner$Job.run(LocalJobRunner.java:212)
```

**原因分析**：local模式下所有pig脚本任务的起始jobID都是1，因此可以想像多个pig脚本执行的maprdeuce任务的临时目录就会出现冲突，因此会发生多个任务同时在操作一个文件。但是这个并不能算是pig的bug，因为一般local模式主要是为了测试和调试使用，

**解决方案**：最直接的解决方案，既然临时目录冲突，那就为每个pig脚本配置一个不同的临时目录：

``` pig
set hadoop.tmp.dir '/unique/tmp/path/hadoop-tmp';
```

### 2. define关键字的坑

**问题描述**：说是坑有点勉强，主要是理解define的本质，define可以定义pig的函数，在pig函数内部也会为每一行的关系命名，直接看下面的函数实例，可以看出每一行的关系名称基本类似'h_$M'这样的名称，而不是类似‘flatten_foreach’这样的固定的名称，如果写成固定的名称，多次调用这个函数，会出现关系名覆盖的问题，导致最终结果不符合预期。

``` pig
define FlattenFunc(MS) RETURNS M {
    h_$M = foreach $MS generate flatten($0) as (s:chararray, a:long, b:chararray, c:long, d:long);
    $M = foreach h_$M generate s, ToDate(ToString(ToDate(a), 'yyyyMMddHH'), 'yyyyMMddHH') as a, b..d;
};
```

**原因分析**：define定义的并非一个函数，而是类似C语言中的define，是一个宏定义，这个在pig执行之前先将所有的difine进行字符串替换，其实最终执行的脚本都没有所谓的函数，如果在define里关系名称是固定的名称，如果在同一个脚本中多次调用，那么很明显，这个名字就在脚本中重复了，前面的关系将被后面同名的关系覆盖。

**解决方案**：理解define的本质含义：跟C语言中的difine类似，都是字符串的替换。

### 3. foreach嵌套的坑

**问题描述**：foreach嵌套语句导致OOM，例如下面的语句，原始数据比如是100W，group最终结果是一条，那么在有限的内存下就会产生OOM。

``` pig
xf = foreach src generate a, b, c, d, e;
xg = group xf by (a, b, c, d);
x = foreach xg {
	fa = filter xf by e is not null and (e=='AD_SUCCESS' or e=='BID_FAILED');
	fb = filter xf by e is not null and e=='AD_SUCCESS';
	generate flatten(group), COUNT(fa), COUNT(fb);
}
```

**原因分析**：从之前对pig的了解，以及实际执行的现象看，foreach的嵌套在pig中进行了特殊的处理，跟外部的语句的处理有较大的区别，foreach嵌套的语句在一些情况会导致相关的数据全被加载到内存中处理，所以如果对嵌套执行的数据量比较大的话，可能导致OOM。具体的foreach嵌套的原理还没详细分析。

**解决方案**：对于foreach嵌套使用，虽然灵活，但是要慎重，避免这种情况的发生。比如上面的例子可以用下面的pig中的case语句替换实现：

``` pig
xf = foreach src generate a, b, c, d, case when (e is not null and (e=='AD_SUCCESS' or e=='BID_FAILED')) then 1 else 0 end as fa, case when (e is not null and e=='AD_SUCCESS') then 1 else 0 end as fb;
xg = group xf by (a, b, c, d);
x = foreach xg generate flatten(group), SUM(xf.fa), SUM(xf.fb);
```

## Pig有用的特性

### 1. pig在同一个load多个store上所进行的优化

**描述**：考虑这样一种场景，读取一份原始数据，生成多张不同维度的报表，pig脚本写法就是：在一个pig脚本中，从一个数据源中load数据，分别对不同维度进行统计分析最终生成多个统计报表，也就是最终执行多个store。因为是同一份数据，因此如果直接写MapReduce，可能一个MapReduce就可以同时将这几个报表都生成了，那么pig最终会用一个MapReduce分析，还是不同的store会产生多个MapReduce？

**结论**：其实pig这方面优化做的很好，也是能够比hive性能高的一个方面，pig最终只会用一个mapreduce生成这个分析。这个能力来自于pig在执行之前，首先是会生成一个执行计划，执行计划阶段能够做很多优化，其中一项就是将能够合并的操作进行合并，对于这个场景，因为来自于同一数据源，pig在生成执行计划时能够识别这种可以的合并，最终只会有一个MapReduce执行。如果这操作在hive中实现，由于生成多张报表，因此必然会有多个SQL语句，因而必然会有多个MapReduce执行，而且pig在这方面的优化还不仅仅这是这个。

### 2. pig对控制语句支持的缺失

**描述**：pig中并没有类似高级程序语言的控制语句，因此你不可能写出一个pig脚本，控制内部语句的执行流程，pig的语句只会逐条分析生成执行计划，然后执行。

**结论**：缺失控制语句，只能说是pig侧重的方向不同，这个可以通过用其他脚本配合pig使用来解决这个问题，比如pig+shell或者pig+python，都可以解决这个问题。

### 3. pig中有用的关键字describe

**描述**：在理解的pig的基本语法和用法后，常用describe，不仅能够解决pig中的问题，而且有助于理解pig处理的机制。

（持续补充中...）


## Pig学习过程中参考的资料

[0.16.0官方文档](http://pig.apache.org/docs/r0.16.0/index.html)

《pig编程指南》
《hadoop权威指南》第三版
[Pig完全入门](https://www.zybuluo.com/BrandonLin/note/449340)
