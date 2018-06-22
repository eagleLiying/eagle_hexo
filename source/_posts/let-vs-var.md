---
title: let、var、const
date: 2018-06-22 11:20:15
tags: js
---

let、var、const 都是用来声明变量的，但是 let 、const 是为了了弥补 var 在作用域上的一些缺陷而引入的，同时在 ES6 中引入块级作用域。

## 首先来说 let 和 var 的异同。

` let ` 声明的用法与 ` var ` 一致，` let ` 声明的变量可以把变量限制在作用域的代码中。

1. 声明后未赋值，表现相同

```
(function() {
  var varTest;
  let letTest;
  console.log(varTest); //输出 undefined
  console.log(letTest); //输出 undefined
}());
```

2. 使用未声明的变量，表现不同

```
(function() {
  console.log(varTest); //输出 undefined
  console.log(letTest); //输出 Error: letTest is not defined

  var varTest = 'test var OK.';
  let letTest = 'test let OK.';
}());
```

3. 不允许重复申明一个变量

```
(function() {
  var varTest = 'test var OK.';
  let letTest = 'test let OK.';

  var varTest = 'varTest changed.';
  let letTest = 'letTest changed.'; //直接报错：SyntaxError: Identifier 'letTest' has already been declared

  console.log(varTest); //输出varTest changed.(注意要注释掉上面letTest变量的重复声明才能运行)
  console.log(letTest);
}());
```

4. 不同作用域申明变量不一样

```
(function() {
  var varTest = 'test var OK.';
  let letTest = 'test let OK.';

  {
    var varTest = 'varTest changed.';
    let letTest = 'letTest changed.';
  }

  console.log(varTest); //输出"varTest changed."，内部"{}"中声明的varTest变量覆盖外部的letTest声明
  console.log(letTest); //输出"test let OK."，内部"{}"中声明的letTest和外部的letTest不是同一个变量
}());
```

## const

1. ` const ` 声明的是常量，起止一旦设定后不可修改。因此，` const ` 常量声明是必须进行初始化。

2.  ` const ` 声明的常量和 ` let ` 一样都有作用域的限制。

3. 常量也不可以重复声明变量，无论该变量是 ` var ` 或者 ` let ` 声明的。