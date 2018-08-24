---
title: windows 环境安装 git
date: 2018-08-24 14:37:43
tags: ['git', 'windows'] 
---

对于开发者，在 windows 环境下安装 git 会有两个步骤：

### 1. 下载 
[windows 版的 git 包](https://gitforwindows.org/)

### 2. 安装
下载完成之后进行安装，很普通安装的过程一致。（一直点击下一步就行了）

### 3. 配置环境变量
安装完成之后，最关键的步骤来了，配置环境变量
1. 右键单击“计算机”，选择“属性”;
    ![](/images/git-computer.jpg)

2. 选择左侧栏的 “高级系统设置” 选项;
    ![](/images/git-set.jpg)

3. 在属性系统中选择 “环境变量”;
    ![](/images/git-env.jpg)

4. 选择 “path” 选项
    ![](/images/git-path.jpg)

5. 复制安装的 git 目录下的 bin（如 C:\Program Files (x86)\Git\bin ）添加到 PATH 环境变量。保存之后，就可以在 cmd 和 git bash 中使用 git 了。

> 注意：在添加环境变量的时候是以 ";" 隔开每个路径的。

可以右键单击看看菜单栏是否已经有了 git bash。:)