---
title: npm 安装包管理
date: 2018-11-06 14:49:29
tags: ['npm', 'package.json']
---

最近对于公开自己封装的组件比较感兴趣，所以总结一下如何在 npm 公开自己安装包。

## 新建自己的项目包

本地环境： node

### 1. 注册自己账号

进入 [npm](https://www.npmjs.com) 进行注册自己的账号

### 2. 本地登录

第一次发布包输入如下指令：
```js
$ npm adduser  // 会提示输入账号密码，然后将提示创建成功
```

第二次发布包的话进行登录：
```js
$ npm login  // 如果你已经登录就不用登录了
```

### 3. 创建一个简单的包

创建一个简单的安装包：
```js
$ mdkir test
$ cd test
$ npm init
$ touch index.js
```
在 index.js 中写入：

```js
export default 'test'
```

### 4. 发布包

执行一下指令：
```js
$ cd ..  // 退出项目文件外，进入项目外一层
$ npm publish test  // test 为需要发布的安装包
```

> 注意 `package.json` 中的 `main` 的值，默认为 `index.js`，一般情况下我设置成 `dist/index.js`，这个为入口文件，具体 `files` 设置成什么，最后的安装这个安装包的时候会下载什么文件夹。

执行成功之后，这个时候可以进去 npm 官网查看自己的发布的包 test。版本为 0.0.1

### 5. 更新安装包

1. 修改 test 项目内容，然后更新项目包。
2. 修改 package.json 的 version 版本。（很重要）

```js
$ cd test
$ npm publish  
```

## npm 常用的指令

1. 初始化一个 npm 项目:
```js
$ npm init 
```
2. 安装模块包:
```js
$ npm install xxx // 如果安装某个版本 xxx@1.2.0
```
3. 卸载模块包:
```js
$ npm uninstall xxx // 如果安装某个版本 xxx@1.2.0，--save-dev 代表安装再 devDependencies
```
4. 更新模块包:
```js
$ npm uninstall xxx
```
5. 搜索模块包是否存在:
```js
$ npm search xxx
```
6. 查看过期的模块包：
```js
$ npm outdated
```
7. 更新模块包
```js
$ npm update xxx
```
8. 查看包的依赖关系
```js
$ npm view xxx dependencies
```