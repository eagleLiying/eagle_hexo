---
title: vue 初探（一）
date: 2019-01-17 09:05:06
tags: ["js", "vue"]
---

一直在使用 react ，但是对 [vue](https://cn.vuejs.org/v2/guide/installation.html#Vue-Devtools) 一直有一定的兴趣，所以记录一下自己学习 vue 的一些过程。

##  安装
对 Vue 还不是很理解，所以先安装一下吧：

```js
# 最新稳定版
$ npm install vue
```

然后我看到官网上提供了 vue 的一个脚手架 [vue-cli](https://cli.vuejs.org/zh/guide/creating-a-project.html)
安装 vue-cli

```js
$ npm install -g @vue/cli
# OR
$ yarn global add @vue/cli

// 安装完成之后可以通过一下指令查看是否安装成功
$ vue --version
```

## 创建一个新项目

我的思路是先对 vue 有一个大概的了解之后再去看详细的细节，所以我选择先使用 vue-cli 脚手架搭建一个小项目，便于自己了解 vue。

```js
$ vue create api-vue
```

中间会有很多安装项目，我就先全部使用默认的添加项了。但是这块应该在 windows 和 mac 上会有所差别，可能在 windows 上有问题，具体提示查看 [vue-cli 创建项目](https://cli.vuejs.org/zh/guide/creating-a-project.html)

比较让我惊喜的是 vue-cli 提供了一个图形界面用于管理项目(虽然目前不知道这个东西怎么用):

```js
$ vue ui
```

查看 package.json 文件发现有对应的指令：

```js
$ yarn serve  // 启动项目
```

然后打开 http://129.0.0.1:8080 就可以看到初始化的项目了。

## 添加路由

安装官方提供的 `vue-router`, 具体怎么使用可以查看 [vue-router 官方文档](https://router.vuejs.org/zh/installation.html)
<br />
我就简单记录一下我在使用过程中遇到的问题和解决步骤,
<br />

```js
$ npm install vue-router
```

简单说一下 vue-router 的功能：（官网上粘出来的）

1. 嵌套的路由/视图表
2. 模块化的、基于组件的路由配置
3. 路由参数、查询、通配符
4. 基于 Vue.js 过渡系统的视图过渡效果
5. 细粒度的导航控制
6. 带有自动激活的 CSS class 的链接
7. HTML5 历史模式或 hash 模式，在 IE9 中自动降级
8. 自定义的滚动条行为

我按照官网上配置出来之后的结果就是：

```js
// index.html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0" />
    <link rel="icon" href="<%= BASE_URL %>favicon.ico" />
    <title>api-vue</title>
  </head>
  <body>
    <noscript>
      <strong>We're sorry but api-vue doesn't work properly without JavaScript enabled. Please enable it to continue.</strong>
    </noscript>
    <div id="app"></div>
    <!-- built files will be auto injected -->
  </body>
</html>


// main.js
import Vue from 'vue'
import VueRouter from 'vue-router'

const Foo = { template: '<div>foo</div>' }
const Bar = { template: '<div>bar</div>' }

const routes = [
  { path: '/foo', component: Foo },
  { path: '/bar', component: Bar }
]

const router = new VueRouter({
  routes
})

new Vue({
  router
}).$mount('#app')
```

#### 问题：

<b>1. 运行结果会报错：</b>

```js
You are using the runtime-only build of Vue where the template compiler is not available. Either pre-compile the templates into render functions, or use the compiler-included build.
```

<b>问题产生原因：</b><br />
通过 `import Vue from 'vue'` 导入的是 `vue.common.js`, 而 vue-router 内部导入使用的是 `vue.js`，在 node_modules/vue/package.json 中的 main 字段是：`"main": "dist/vue.runtime.common.js",`，瞬间恍然大悟，他默认导出的是 `"dist/vue.runtime.common.js"` 不是 `vue.js`。
<br /><b>解决方案：</b><br />
我把项目中的 `import Vue from 'vue'` 改为：`import Vue from 'vue/dist/vue'`, 特别开心的是不报错了，但是就是没有出来内容，页面是空白一片。

<b>2. 页面空白</b><br />
我纠结了半天想着，这样路由是定义好了，但是具体每个页面对应的每个模块要渲染的位置我并没有指定，所以我觉的页面空白一片是正常现象，所以我就看是看 `router-view` 的用法，查看了 [vue-router GitHub 的 base 例子](https://github.com/vuejs/vue-router/tree/dev/examples/basic)，
<br />
<b>解决方案：</b><br />
于是我给我的代码添加了 `Vue.use(VueRouter); 和 new Vue({..., template: ...})` 具体代码如下：

```js
import Vue from "vue/dist/vue";
import VueRouter from "vue-router";
Vue.use(VueRouter);

const Home = { template: "<div>我是 Home 页</div>" };
const Foo = { template: "<div>我是 foo 页</div>" };
const Bar = { template: "<div>我是 bar 页</div>" };

const routes = [
  { path: "/", component: Home },
  { path: "/foo", component: Foo },
  { path: "/bar", component: Bar }
];

const router = new VueRouter({
  routes
});

new Vue({
  router,
  template: `
  <div id="app">
    <h1>Hello Vue-router </h1>
    <ul>
      <li><router-link to="/">/</router-link></li>
      <li><router-link to="/foo">/foo</router-link></li>
      <li><router-link to="/bar">/bar</router-link></li>
    </ul>
    router-view content:
    <router-view class="view"></router-view>
  </div>
`
}).$mount("#app");
```
再次运行，开心，页面终于出来了，而且路由页正常的运行。。。。😁 😁 😁 😁 😁 😁
