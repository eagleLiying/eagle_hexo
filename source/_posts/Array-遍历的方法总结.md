---
title: Array 遍历的方法总结
date: 2019-01-09 17:39:06
tags: js
---

## for 循环

```js
// 普通用法
for (j = 0; j < array.length; j++) {
  //  TODO...
}

// 优化写法1
for (j = 0, length = array.length; j < length; j++) {
  //  TODO...
}

// 优化写法2
for (var i = array.length - 1; i >= 0; i--) {
  //  TODO...
}
```

优化小点：使用临时变量，将长度缓存起来，避免重复获取数组长度，当数组较大时优化效果才会比较明显。

常见问题：

```js
const array = [];
for (var i = 0; i < 10; i++) {
  array.push(function() {
    return console.log(i);
  });
}
array[0](); // 10
array[1](); // 10
array[2](); // 10

// 优化 将 var 改为 let
const array = [];
for (let i = 0; i < 10; i++) {
  array.push(function() {
    return console.log(i);
  });
}
array[0](); // 10
array[1](); // 10
array[2](); // 10
```

原因：

1. var 没有作用域指定, 所以在 for 循环中使用 var 声明的变量是全局变量，而使用 let 声明的变量是仅仅在 for 循环这个块作用域中的。
2. for 循环中的匿名函数只是声明了，并没有在当时调用，随后调用的时候已经全局变量 i 已经被修改为 10 了。

## Array.foreach

用法:

```js
array.forEach((currentValue, index, array) = {
 // TODO....
}, thisValue)
```

特点：

1. 不修改原数组；
2. 没有返回值；
3. 不支持 ie 浏览器

## Array.map

用法：

```js
array.map((currentValue, index, array) = {
 // TODO....
})
```

特点：

1. 有返回值；
2. 对原数组没有影响；
3. 不支持 IE 浏览器

## Array.some

用法：用于检测数组中的元素是否满足指定条件

```js
array.some(function(currentValue,index,arr),thisValue)

// eg:
const ages = [3, 10, 18, 20];

ages.some((age) => age > 4); // true
ages.some((age) => age < 2); // false

```

特点：

1. 返回值为布尔值。如果数组中有元素满足条件返回 true；否则返回 false，剩余的元素不会再执行检测。
2. some() 不会对空数组进行检测；
3. some() 不会改变原始数据；
4. 兼容 IE9 以上，包括 IE9；
5. javascript 版本 1.6

## Array.filter

用法：创建一个新的数组，新数组中的元素是通过检查指定数组中符合条件的所有元素。

```js
array.filter(function(currentValue,index,arr), thisValue);

// eg:
const ages = [32, 33, 16, 40];
const bigAges = ages.filter((age) => age > 30) // [32, 33, 40]
const minAges = ages.filter((age) => age < 30) // [16]
```

特点：

1. filter() 不会对空数组进行检测
2. filter() 不会改变原始数据
3. 兼容 IE9 以上，包括 IE9
4. 返回数组，包含了符合条件的所有元素。如果没有符合条件的元素则返回空数组。
5. javascript 版本 1.6

## Array.find

用法：查找符合条件的值

```js
array.find(function(currentValue, index, arr),thisValue)

// eg:
const ages = [3, 10, 18, 20];
ages.find((age) => age >= 18) // 返回 18
```

特点：

1. 返回值为通过测试的第一个值；
2. 当 find 回调函数返回的 true 时，之后的元素将不会再执行函数；
3. 如果没有符合条件的元素返回 undefined ；
4. 不会执行空数组
5. 不会改变原数组
6. 不兼容 IE

## Array.reduce

用法：累加器

```js
// 参数说明：
// 1. total 为上一次执行返回的结果
// 2. currentValue 当前循环的值
// 3. currentIndex 当前循环的索引值
// 4. arr 当前的原数组
// 5. initialValue 初始返回值
array.reduce(function(total, currentValue, currentIndex, arr), initialValue)

// eg:
const numbers = [65, 44, 12, 4];
const sum = numbers.reduce((total, num) => total + num, 0); // 125
```

特点：

1. 返回计算结果
2. JavaScript 版本为 ECMAScript 3
3. 不执行空数组
4. 不兼容 IE

## Array.includes

定义：判断数组是否包含一个指定的值，如果包含返回 true, 否则返回 false
用法：

```js
// searchElement 需要查找的元素值
// formIndex 要开始搜查的索引，如果为负值从 array.length + fromIndex 的索引开始搜索，默认为 0
arr
  .includes(searchElement, fromIndex)

  [
    // eg:
    (1, 2, 3)
  ].includes(2); // true
[1, 2, 3].includes(4); // false
[1, 2, 3].includes(3, 3); // false
[1, 2, 3].includes(3, -1); // true
[1, 2, NaN].includes(NaN); // true
```

特点：

1. 返回值为布尔值
2. JavaScript 版本为 ECMAScript 6
3. 不兼容 IE

以上只是总结了常用又经常搞混的数组方法，如果想要更全面的数组方法请参考：[菜鸟教程-Array](http://www.runoob.com/jsref/jsref-obj-array.html)
