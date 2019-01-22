---
title: Vue 初探（三）-- 基础语法篇
date: 2019-01-22 13:41:37
tags: ['js', 'vue']
---

## 计算属性
1. wath: 当需要在数据变化时执行异步或开销较大的操作时，这个方式是最有用的
2. computed(计算属性): 是基于它们的依赖进行缓存的， 用于进行简单的计算，get 居多，set 居少
3. methods: 方法

## 绑定
1. v-bind 简写 : 绑定元素属性
2. v-on 简写 @ 绑定事件

## class and style 
1. class 和 v-bind:class 不冲突，可以些简单的表达式或者计算属性

2. v-bind:style   可以是一个对象和变量，会自动添加前缀，也可以添加多重值：
```
<div :style="{ display: ['-webkit-box', '-ms-flexbox', 'flex'] }"></div>
```

## 条件判断
 - | 缺点 | 适用场景 | 特点 |
---- | --- | --- | ---
v-if | 是更高的切换开销 | 在运行时条件很少改变的情况下使用 | v-else  v-else-if 必须与 v-if 成对出现，可以通过制定key 来控制元素是否被复用，如果不指定，默认复用，key 一致，
v-show | 有更高的初始渲染开销， | 在需要非常频繁地切换时使用 | 元素肯定会被渲染，只是显示不显示的问题

## 遍历

#### Array
适用 `v-for` 配合 `(item, index) in items`，item 指代循环列表中的某一项,index 指代循环的索引，也可以使用 `of` 代替 `in`
```js
// html  v-for... in...
<ul id="example-2">
  <li v-for="(item, index) in items">
    {{ parentMessage }} - {{ index }} - {{ item.message }}
  </li>
</ul>
// html  v-for...of...
<ul id="example-2">
  <li v-for="item of items">
    {{ parentMessage }} - {{ index }} - {{ item.message }}
  </li>
</ul>
// js
var example1 = new Vue({
  el: '#example-1',
  data: {
    items: [
      { message: 'Foo' },
      { message: 'Bar' }
    ]
  }
})
```
#### Object

`v-for` 也可以用于遍历对象，配合 `(value, key) in object`

```js
// html
<div v-for="(value, key) in object">
  {{ key }}: {{ value }}
</div>
// js
new Vue({
  el: '#v-for-object',
  data: {
    object: {
      firstName: 'John',
      lastName: 'Doe',
      age: 30
    }
  }
})
```

> 可能在不同的 JavaScript 引擎下渲染不一致

> 注意：`v-for` 优先级高于 `v-if`


## 表单的绑定

使用 `v-model` 在表单 `<input />`、`<textarea>`、`<select>`、`checkbox`、`radio` 会忽略掉所有的value、checked、selected 来实现双向绑定。初始值可以在 data 中去指定。
例如：
```js
// 单行输入框
<input v-model="message" placeholder="edit me">
<p>Message is: {{ message }}</p>

// 多行输入框
<span>Multiline message is:</span>
<p style="white-space: pre-line;">{{ message }}</p>
<br>
<textarea v-model="message" placeholder="add multiple lines"></textarea>
 
//  单个复选框
<input type="checkbox" id="checkbox" v-model="checked">
<label for="checkbox">{{ checked }}</label>

//  多个复选框
<div id='example-3'>
  <input type="checkbox" id="jack" value="Jack" v-model="checkedNames">
  <label for="jack">Jack</label>
  <input type="checkbox" id="john" value="John" v-model="checkedNames">
  <label for="john">John</label>
  <input type="checkbox" id="mike" value="Mike" v-model="checkedNames">
  <label for="mike">Mike</label>
  <br>
  <span>Checked names: {{ checkedNames }}</span>
</div>

// 单选
<div id="example-4">
  <input type="radio" id="one" value="One" v-model="picked">
  <label for="one">One</label>
  <br>
  <input type="radio" id="two" value="Two" v-model="picked">
  <label for="two">Two</label>
  <br>
  <span>Picked: {{ picked }}</span>
</div>

// 选择框
<div id="example-5">
  <select v-model="selected">
    <option disabled value="">请选择</option>
    <option>A</option>
    <option>B</option>
    <option>C</option>
  </select>
  <span>Selected: {{ selected }}</span>
</div>


```

单个复选框可以指定 `true-value` 和 `false-value` 去控制 value 输入的特性
```js
<input
  type="checkbox"
  v-model="toggle"
  true-value="yes"
  false-value="no"
>
```

修饰符：
1. `.lazy`  在“change”时而非“input”时更新 
2. `.number` 返回数字，如果不能被 `parseFloat()` 识别，就自动返回原始值
3. `.trim` 自动过滤到收尾的空白字符

```js
<input v-model.lazy="msg" >
<input v-model.number="age" type="number">
<input v-model.trim="msg">
```
