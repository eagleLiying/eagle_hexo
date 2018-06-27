---
title: git 账户切换的怪异处理方式
date: 2018-06-09 21:44:35
tags: git
categories: 指令
---

在平时一个电脑上切换 git 账户时你发现很多烦人的问题，明明已经切换过来了，但是最终的结果，在你提交代码的时候发现总是给你报错导致你提交代码是啊，现在本人找出了一个小小的解决方案就是“修改 deploy key”

指令： ssh-keygen -t rsa -b 4096 -C "xxx@xxx.xx"

执行之后会在你的电脑更目录下生成一个 .ssh 文件夹，其中会有两个文件：id_rsa 和 id_rsa.pub 
在你的编辑器里打开 id_rsa.pub
复制里面的 key 值，在你的 github 账户中项目的 setting 中的 deploy 配置中添加一个新的 deploy key ，记得勾选是否允许写入，否则的话你是只读的，同样推代码推不上去。
保存之后就OK了  ：）
