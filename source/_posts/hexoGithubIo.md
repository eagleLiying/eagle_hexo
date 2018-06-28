---
title: hexo + github.io
date: 2018-06-06 00:14:18
tags: hexo
categories: 环境
---

### 第一步：需要的环境：
   node环境  （[立即下载](https://nodejs.org/zh-cn/)）
   git 环境  （[立即下载](https://git-scm.com/download/)）
   因为习惯使用 yarn，所以如果你的环境中没有 yarn，那就需要安装。
    [安装 homebrw](https://brew.sh/)
    [安装 yarn](https://yarnpkg.com/en/docs/install#mac-stable)
### 第二步：安装 hexo:
([也可以按照官方网站就行安装](https://hexo.io/zh-cn/docs/index.html))
1. 安装 hexo
```
$ yarn add -g hexo-cli
```
2. 创建一个新的 hexo 项目
```
$ hexo init blog（项目名字）
cd blog
$ yarn install
```
3. 启动项目
```
$ hexo server   // 启动之后再浏览器中打开 http://localhost:4000
```

项目文件结构为：

![](/images/hexo-page.png)

至此，我们本地的一个博客环境就已经搭建完成。
常用的指令如下：([具体参数使用前查看详细文档](https://hexo.io/zh-cn/docs/commands.html))
```
$ hexo server = hexo s  // 启动项目
$ hexo new = hexo n   // 创建新的文章，如果想要创建一个新页面需要加 page ,例如：$ hexo new page newPage
$ hexo generate = hexo g  // 生成静态文件到 public 文件夹中
$ hexo deploy = hexo d   // 部署播客到远端（比如github, heroku等平台）
```
### 第三步：更换主题
现在为自己的博客找一个喜欢的主题：
1. 进入[hexo 主题库](https://hexo.io/themes/)，选择一个自己喜欢的主题
2. 点击自己喜欢的主题名字，进入对应主题的 github 项目中，可以通过 download 或者 git clone 的方式将主题下载下来
3. 将下载下来的主题文件夹放在项目目中中的 themes 文件家中，修改 _config.yml 文件中的 theme 值为你下载的主题名字

当前我所用的主题为 [clean-blog](https://github.com/klugjo/hexo-theme-clean-blog)

### 第四步：搭建免费的 github.io 服务器

首先明白什么是 github pages:
GitHub Pages 本用于介绍托管在GitHub的项目，不过，由于他的空间免费稳定，用来做搭建一个博客再好不过了。

每个帐号只能有一个仓库来存放个人主页，而且仓库的名字必须是username/username.github.io，这是特殊的命名约定。你可以通过http://username.github.io 来访问你的个人主页。

***特别注意：新建的项目名字必须是 usename.github.io。个人主页的网站内容是在master分支下的***


1. 注册一个 github 账号，（例：用户名为eagle）激活之后，新建一个空项目名称为 eagle.github.io。

2. 将本地环境推上线上环境，
    1. 首先需要知道，如果直接访问 http://eagle.github.io 的时候，他会直接去找根目录下的 index.html 的静态文件。
    2. Hexo -g 会生成一个静态网站（第一次会生成一个public目录），这个静态文件可以直接访问
    3. 需要将hexo生成的静态文件，提交 commit 推到github上

部署的方法一：
hexo deploy ，可以参考 [官方的文档](https://hexo.io/docs/deployment.html)

安装 hexo-deployer-git
```
$ yarn add hexo-deployer-git
```
配置：_config.xml
```
deploy:
  type: git
  repo: git@github.com:jiji262/jiji262.github.io.git
  branch: master
```
执行：
```
$ hexo d
```

执行之后可能会报错：
```
Permission denied (publickey).
fatal: Could not read from remote repository.
Please make sure you have the correct access rights
and the repository exists.
```
则是因为没有设置好public key所致。
在本机生成public key[参考github帮助](https://help.github.com/articles/connecting-to-github-with-ssh/)
```
$ ssh-keygen -t rsa -b 4096 -C "xxx@xxx.com"
```
然后在 user_id/.ssh 目录下会生成两个文件，id_rsa.pub和id_rsa.
然后登陆github，在SSH设置页面添加上刚才的public key文件也就是id_rsa.pub的内容即可。

根据本人尝试，问题出在自己的 github 账户切换出现的奇怪的 bug，设置好各种 deploy key 或者 public key 之后任然不行的话，可以尝试手动推送项目。

部署方法二：

将我们之前创建的repo克隆到本地，新建一个目录叫做deploy用于存放克隆的代码。

写一个发布脚本：deploy.sh
```
hexo generate
cp -R public/* deploy/eagle.github.io
cd deploy/eagle.github.io
git add .
git commit -m “update blog”
git push origin master
```

做的事情很简单：复制 public 文件中的代码到 depoly/eagle.github.io 文件中，提交 commit ，推送代码到远程。

至此，一个简单的博客建完  ^ - ^