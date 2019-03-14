---
title: amd umd cmd
date: 2019-03-05 13:20:20
tags: js
---

## AMD

AMD (Asynchromous Module Definition - 异步模块定义) 是 requirejs 在推广过程中对模块定义规范化产出的，AMD 是异步加载模块，推崇依赖前置

#### 特点：
1. 异步加载
2. 管理模块之间的依赖性，便于代码的编写和维护
3. 环境：浏览器环境

#### 写法：
导入: `require(['模块名称'], function('模块引入变量'){    // TODO....   })`;

导出：`define(function(){   return "某写值"  })`;

#### demo

1. 导入导出demo
```js
// testA.js
define(function (){
　　return {
　　　a:'hello! I am testA'
　　}
});
// testB.js
require(['./testA.js'], function (moduleA){
    console.log(moduleA.a); // 打印出：hello! I am testA
});
```
2. 依赖加载 demo
```js
define('module1', ['jquery'], ($) => {
  //TODO.....
});
```
当定义模块（module1）时，就会加载依赖（jquery)

## CMD

CMD（Common Module Definition - 公共模块定义）是 Seajs 在推广过程中对模块定义的规范化产出，对于模块的依赖，CMD 是延迟执行，推崇依赖就近，CMD 是在 AMD 基础上改进的一种率规范。同时CMD也是延自CommonJS Modules/2.0规范。
#### 特点
1. CMD 与 AMD 的区别是 CMD 是就近依赖， AMD 是前置依赖
2. 环境：浏览器环境

#### 语法
导入：`define(function(require, exports, module) {  // TODO... });`

导出：`define(function (){return '值');`

#### demo

1. 导出导出 demo
```js
// testA.js
define(function (require, exports, module){
　　exports.a = 'hello! I am testA';
});

// testB.js
define(function (require, exports, module){
    var moduleA = require('./testA.js');
    console.log(moduleA.a); // 打印出：hello! I am testA
});
```

2. 依赖 demo

```js
define((require, exports, module) => {
    module.exports = {
        function1: () => {
            var $ = require("jquery");
            return $("#test")
        }
    }
})
```
以上代码只有真正执行到 function1 方法时，才会去执行导入 jquery

## CommonJS

CommonJS 是服务端模块的规范，由于 Nodejs 被广泛认知，Commonjs 规范中一个单独的文件就是一个模块，加载模块使用 require 方法，该方法读取一个文件并执行，最后返回文件内部的 module.exports 对象。

#### 特点
1. 模块可以多次加载，但是只会在第一次加载时运行一次，然后将运行结果进行缓存，之后的加载就直接读取缓存结果。如果想要模块再次运行必须清除缓存。
2. 同步加载（会阻塞接下来代码的执行）
3. 环境：服务器环境

#### 语法

导入：`require('路径')`

导出: `module.exports和exports`

> exports 和 module.exports 的区别:
> exports 只是 module.exports 的一个引用，相当于在每个模块的头部都有一句 `var exports = module.exports`

#### demo

1. 导出导出 demo
```js
// testA.js
exports.a = "Hello TestA"

// testB.js
var moduleA = require("./testA.js);
console.log(moduleA.a)  // 输出 Hello TestA
```

## UMD

UMD（Universal Module Definition - 通用模块定义） 是 AMD 和 CommonJS 的糅合，AMD 是浏览器优先异步加载，而 CommonJS 是服务器优先同步加载，如果想要同时支持需要区分他们，方法如下：
1. 判断 nodejs 模块存在就是用 nodejs (CommonJS)
2. 判断 define 存在就使用 AMD 的加载

#### 特点
1. 同时包含 AMD 和 CommonJS 两种语法
2. 环境：浏览器环境（AMD）和服务器环境(CommonJS)
3. 无导入导出规范

#### demo

```js
(function (root, factory) {
    if (typeof define === 'function' && define.amd) {
        //AMD
        define(['jquery'], factory);
    } else if (typeof exports === 'object') {
        //Node, CommonJS之类的
        module.exports = factory(require('jquery'));
    } else {
        //浏览器全局变量(root 即 window)
        root.returnExports = factory(root.jQuery);
    }
}(this, function ($) {
    // 真正的函数体
    //方法
    function myFunc(){};
    //暴露公共方法
    return myFunc;
}));

```

## ES6 module

#### 特点

1. ES6 的最新语法支持规范


#### 导入导出

导入 
1. `import Module, { ModuleA, ModuleB } from './moduleA.js'`
2. `import("./moduleA").then()`

导出：`export ModulA` 和 `export default Module`

> 注意：export 只支持对象形式导出，不支持值的导出，export default 导出的是默认导出，只支持 值的导出，但是只能指定一个。本质上它输出一个 default 的变量或者方法

#### demo

```js
/*错误的写法*/
// 写法一
export 1;

// 写法二
var m = 1;
export m;

// 写法三
if (x === 2) {
  import MyModual from './myModual';
}

/*正确的三种写法*/
// 写法一
export var m = 1;

// 写法二
var m = 1;
export {m};

// 写法三
var n = 1;
export {n as m};

// 写法四
var n = 1;
export default n;

// 写法五
if (true) {
    import('./myModule.js')
    .then(({export1, export2}) => {
      // ...·
    });
}

// 写法六
Promise.all([
  import('./module1.js'),
  import('./module2.js'),
  import('./module3.js'),
])
.then(([module1, module2, module3]) => {
   ···
});
```