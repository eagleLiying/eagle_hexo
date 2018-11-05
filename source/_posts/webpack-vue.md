---
title: webpack + vue
date: 2018-11-05 14:57:37
tags: ['webpack', 'vue', 'js']
---


Webpack + vue 环境搭建比 react 环境搭建简单很多，直接使用官方推荐的脚手架 [vue-cli](https://github.com/vuejs/vue-cli)。

和其他一样环境搭建一样依赖 node 和 npm。

## 1. 安装 vue-cli 

```js
npm install -g vue-cli
```

可以输入 `vue -V` 查看安装成功后的版本

## 2. 安装 webpack 模板项目
安装完成之后可以输入 `vue list` 查看 vue 可以使用的模板：

![](/images/vueWebpack/vue-list.png)

我们就可以选择 webpack 模板，执行以下指令：

```js
$ vue init webpack webpack-vue
```

这个和 `npm init` 初始化项目差不多，可以输入项目名字和版本等。

## 3. 启动
```js
$ cd webpack-vue
$ npm run dev
```

输入 localhost:8080 查看结果。