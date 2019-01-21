---
title: Vue 初探（二）—— 生命周期篇
date: 2019-01-21 14:47:35
tags: ['js', 'vue']
---

了解了 Vue 的项目创建过程和路由的构建，就需要了解他的生命周期，和 react 的生命周期类似，Vue 也有属于他的生命周期钩子函数。
其他不说先上图：
![](/images/vue/lifecycle.png)

我就文字总结一下自己对 Vue 生命周期的理解。感觉 vue 比 react 的生命周期更简单一些，用过 react 的人一看示意图绝对就明白了。
在实例化一个 Vue 实例时生命周期的钩子函数执行顺序为：
# 初次创建：
#### 初始化时
`beforeCreate: function(){ //TODO... }`
`created: function(){ //TODO... }`
#### 渲染时
`beforMount: function(){ //TODO... }`
`mounted: function(){ //TODO... }`
#### 销毁时
`beforDestroy: function(){ //TODO... }`
`destroyed: function(){ //TODO... }`

# 更新了 data 之后
`beforeUpdate: function(){ //TODO... }`
`updated: function(){ //TODO... }`

> 注意：不要在选项属性或回调上使用箭头函数，比如 `created: () => console.log(this.a)` 或 `vm.$watch('a', newValue => this.myMethod())`。this 的指向会有问题，并且会报错：`Uncaught TypeError: Cannot read property of undefined` 或者 `Uncaught TypeError: this.myMethod is not a function`

```js
/* eslint-disable no-console */
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
`,
  beforeCreate: function() {
    console.group("beforeCreate 创建前状态===============》");
    console.log("%c%s", "color:red", "el     : " + this.$el); //undefined
    console.log("%c%s", "color:red", "data   : " + this.$data); //undefined
    console.log("%c%s", "color:red", "message: " + this.message);
  },
  created: function() {
    console.group("created 创建完毕状态===============》");
    console.log("%c%s", "color:red", "el     : " + this.$el); //undefined
    console.log("%c%s", "color:red", "data   : " + this.$data); //已被初始化
    console.log("%c%s", "color:red", "message: " + this.message); //已被初始化
  },
  beforeMount: function() {
    console.group("beforeMount 挂载前状态===============》");
    console.log("%c%s", "color:red", "el     : " + this.$el); //已被初始化
    console.log(this.$el);
    console.log("%c%s", "color:red", "data   : " + this.$data); //已被初始化
    console.log("%c%s", "color:red", "message: " + this.message); //已被初始化
  },
  mounted: function() {
    console.group("mounted 挂载结束状态===============》");
    console.log("%c%s", "color:red", "el     : " + this.$el); //已被初始化
    console.log(this.$el);
    console.log("%c%s", "color:red", "data   : " + this.$data); //已被初始化
    console.log("%c%s", "color:red", "message: " + this.message); //已被初始化
  },
  beforeUpdate: function() {
    console.group("beforeUpdate 更新前状态===============》");
    console.log("%c%s", "color:red", "el     : " + this.$el);
    console.log(this.$el);
    console.log("%c%s", "color:red", "data   : " + this.$data);
    console.log("%c%s", "color:red", "message: " + this.message);
  },
  updated: function() {
    console.group("updated 更新完成状态===============》");
    console.log("%c%s", "color:red", "el     : " + this.$el);
    console.log(this.$el);
    console.log("%c%s", "color:red", "data   : " + this.$data);
    console.log("%c%s", "color:red", "message: " + this.message);
  },
  beforeDestroy: function() {
    console.group("beforeDestroy 销毁前状态===============》");
    console.log("%c%s", "color:red", "el     : " + this.$el);
    console.log(this.$el);
    console.log("%c%s", "color:red", "data   : " + this.$data);
    console.log("%c%s", "color:red", "message: " + this.message);
  },
  destroyed: function() {
    console.group("destroyed 销毁完成状态===============》");
    console.log("%c%s", "color:red", "el     : " + this.$el);
    console.log(this.$el);
    console.log("%c%s", "color:red", "data   : " + this.$data);
    console.log("%c%s", "color:red", "message: " + this.message);
  }
}).$mount("#app");

```