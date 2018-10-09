---
title: MongoDB 安装
date: 2018-09-29 14:37:49
tags: ['windows', '数据库']
---

每次安装 mongodb 都很费劲，这次就总结一下整个流程（windows-64）

## 下载

在[官网下载中心](https://www.mongodb.com/download-center#community)上下载，如果你直接点击 DIWNLOAD 按钮的话可能需要你填写一些注册信息，其实有一个快捷入口，点击左下角有一个 [ALL Version Binaries](https://www.mongodb.org/dl/win32/x86_64-2008plus-ssl?_ga=2.83391894.1257395547.1538126096-909476422.1538126096) 可以看到所有的历史版本，随便选择一个自己想要的版本下载就好了，

<img src="/images/windows/mongodbDownload.png">

> 注意：
> 1. 选择 Community Server
> 2. 现在 windows 已经不支持 xp 和 32位操作系统

## 安装

安装前：
<img src="/images/windows/mongodbInstall.png">

安装后：
<img src="/images/windows/installed.png">

data: 存放数据
log: 存放记录

## 启动服务器

在Win10中以管理员身份运行cmd命令窗口，执行一下指令：

```js
// 进入安装的mongodb 的 bin 目录下
> cd F:\software\mongodb\bin
// 设置启动
> mongod --dbpath F:\software\mongodb\data --logpath=F:\software\mongodb\log\mongodb.log --logappend
```
<b>注意不要关闭 cmd，否则就会终止启动的服务器</b>
<br />
关于以上命令中的参数说明：

参数 | 描述
---- | --- 
--bind_ip | 绑定服务IP，若绑定127.0.0.1，则只能本机访问，不指定默认本地所有IP
--logpath | 定MongoDB日志文件，注意是指定文件不是目录
--logappend	| 使用追加的方式写日志
--dbpath | 指定数据库路径
--port | 指定服务端口号，默认端口27017
--serviceName | 指定服务名称
--serviceDisplayName | 指定服务名称，有多个mongodb服务时执行。
--install | 指定作为一个Windows服务安装。

## 连接服务器


如果只是想检查服务器是否安装成功有两种方法：
<br />
#### 方法一

你只需要在浏览器中输入：[http://localhost:27017](http://localhost:27017)，或者是 [http://127.0.0.1:27017](http://127.0.0.1:27017)，在浏览器中出现：

It looks like you are trying to access MongoDB over HTTP on the native driver port

则证明安装成功。
<br />
#### 方法二

新打开一个 cmd 窗口，执行一下指令测试一下是否连接成功。

```js
> cd F:\software\mongodb\bin
> mongo
> show dbs  // 列出所有数据库
```
最后输出结果为：(证明你连接成功)
<img src="/images/windows/mongodbShowDB.png" />

常用是数据库指令：
```js
show dbs  //查看mongodb

use a // 创建数据库 a ，切换数据库 a

db.a.insertOne({"key1":"value1","key2":"value2"})//插入一行

db.a.insertMany([{"key1":value1,"key2":"value2"},{"key2":value2},...]) //插入多行

db.a.find()  //查找数据库 里面 所有数据

db.a.find({key:value},{"_id":0}) // {key:value}条件  查找符合这一条件的mongodb,{"_id":0}不想显示  id等条件

db.a.drop()// 删除mongodb的数据库

db.a.remove(query(条件)) //可以根据条件删除 指定的 数据库

db.help()// mongodb的帮助

use music //music 文件夹

db.createCollection("albums") // 链接albums 的集合

db.getCollectionNames()  // 出现 ["albums"]

db.albums.insert([{"key":"value"},{"key1":"value"}]) //新增多条

db。albums.save([{"key":"value"},{"key1":"value"}]) //新增多条

db.albums.find()  //查找 albums 

db.albums.help() //查看所有命令

db.music.find() //music必须得有数据

db.albums.states() //查看状态

db.albums.update(query(查询条件),{$set:{"key":"value"}}) //修改一条

db.albums.updateOne(query(查询条件),{$set:{"key":"value"}})

db.albums.updateMany(query(查询条件),{$set:{"key":"value"}})

mongodb //我本人认为 修改 这一功能 不能够 一次 将 几条数据 分别改成 不一样的 value值
```

## 设置环境变量

将 `F:\software\mongodb\bin` 设置成环境变量就可以再任何盘连接数据库了
（注意：有的电脑可能因为权限问题，在 C 盘不能启动）
<img src="/images/windows/path.png" />

现在可以去其他盘随意连接数据库了

## 将 mongodb 作为 windows 服务启动
(暂未完成)


以上启动服务器只是一次性的，当关闭了命令窗口，服务器即会关闭，可以将mongodb作为windows启动，这样一开机，mongodb服务就已经启动了 


## 参考地址
[https://www.cnblogs.com/hongwest/p/7298257.html](https://www.cnblogs.com/hongwest/p/7298257.html)
[https://www.cnblogs.com/shirly77/p/6536327.html](https://www.cnblogs.com/shirly77/p/6536327.html)