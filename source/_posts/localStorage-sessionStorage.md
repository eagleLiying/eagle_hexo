---
title: cookie、localStorage 和 sessionStorage
date: 2018-06-23 22:23:28
tags: html js
---

### Cookie

cookie 非常小，它的大小限制为4KB左右，它的主要用途有保存登录信息。比如“记住密码”，这通常就是通过在 Cookie 中存入一段辨别用户身份的数据来实现的。

### LocalStorage

localStorage 是 HTML5 标准中新加入的技术。在 IE 6 时代有一个常用的 userData 用作本地存储，当时为了考虑兼容性，使用更多的是 Flash。现在 localStorage 被大多数浏览器支持。

localStorage的优势

1、localStorage 拓展了cookie 的 4K 限制

2、localStorage 会可以将第一次请求的数据直接存储到本地，这个相当于一个 5M 大小的针对于前端页面的数据库，相比于cookie可以节约带宽，但是这个却是只有在高版本的浏览器中才支持的

localStorage的局限

1、浏览器的大小不统一，并且在IE8以上的IE版本才支持localStorage这个属性

2、目前所有的浏览器中都会把localStorage的值类型限定为string类型，这个在对我们日常比较常见的JSON对象类型需要一些转换

3、localStorage在浏览器的隐私模式下面是不可读取的

4、localStorage本质上是对字符串的读取，如果存储内容多的话会消耗内存空间，会导致页面变卡

5、localStorage不能被爬虫抓取到

### SessionStorage

sessionStorage 与 localStorage 的接口类似，但保存数据的生命周期与 localStorage 不同。它只是可以将一部分数据在当前会话中保存下来，刷新页面数据依旧存在。但当页面关闭后，sessionStorage 中的数据就会被清空。

### 三者的异同

特性 | Cookie | localStorage | sessionStorage
---- | --- | --- | ---
数据的生命期 | 一般由服务器生成，可设置失效时间。如果在浏览器端生成Cookie，默认是关闭浏览器后失效 | 除非被清除，否则永久保存 | 仅在当前会话下有效，关闭页面或浏览器后被清除
存放数据大小 | 4K左右 | 一般为5MB | 一般为5MB
与服务器端通信 | 每次都会携带在HTTP头中，如果使用cookie保存过多数据会带来性能问题 | 仅在客户端（即浏览器）中保存，不参与和服务器的通信
易用性	 | 需要程序员自己封装，源生的Cookie接口不友好	 | 源生接口可以接受，亦可再次封装来对Object和Array有更好的支持

### 使用

#### 1. 在使用 localStorage 或者 sessionStorage 之前需要对浏览器的是否支持进行判断，如下：

```js
if(window.localStorage){
    alert("浏览支持localStorage")
}else{
   alert("浏览暂不支持localStorage")
}

//或者
if(typeof window.localStorage == 'undefined'){
    alert("浏览暂不支持localStorage")
}
```

#### 2. setItem 存储数据 value（将value存储到key字段）

localStorage 只支持 string 类型的存储。

这里要特别说明一下localStorage的使用也是遵循同源策略的，所以不同的网站直接是不能共用相同的localStorage

```js
<!-- 在浏览器支持 localStorage 和 sessionStorage 的条件下 -->

const storage=window.localStorage;

// 存储数据方法一
storage["a"]=1;

// 存储数据方法二
storage.a=1;

// 存储数据方法三（官方支持）
localStorage.setItem("site", "js8.in");

sessionStorage.setItem("key", "value");

console.log(typeof storage["a"]);  // 输出：string，原本存入的值是 int 类型，输出的是 string
console.log(typeof storage["b"]);  // 输出：string
console.log(typeof storage["c"]);  // 输出：string
```

#### 3. getItem 获取 value（获取指定key本地存储的值）

```js
const value = sessionStorage.getItem("key");
const site = localStorage.getItem("site");
```

#### 4. removeItem 删除 key（删除指定key本地存储的值）

```js
sessionStorage.removeItem("key");
localStorage.removeItem("site");
```

clear 清除所有的 key/value

```js
sessionStorage.clear();
localStorage.clear();
```

