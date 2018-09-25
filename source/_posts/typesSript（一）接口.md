---
title: typesSript（一）接口
date: 2018-09-25 15:09:43
tags: "ts"
---

#### interface：
类型检查器不会去检查属性的顺序，只要相应的属性存在并且类型也是对的就可以。

1. 可选属性：？
<br />
例如：
```js
interface SquareConfig {
  color?: string;
  width?: number;
}
```

2. 只读属性

例如：

```js
interface Point {
    readonly x: number;
    readonly y: number;
}
```

只读中有：
` ReadonlyArray<T> `类型，它与 ` Array<T> ` 相似，但是他会所以可变的方法都去掉了，以确保数组不能被修改，例如：array[0] = 1、array.push('test')、array.length = 10 等；

需要注意的是：把 `ReadonlyArray` 赋给普通数组也不信，但是可以断言重写：
例如：
```js
let a: number[] = [1, 2, 3, 4];
let ro: ReadonlyArray<number> = a;
<!--错误-->
a = ro; // error!
<!--正确-->
a = ro as number[];
```

3. 定义额外的属性

有时候需要传一些已经定义好的额外的属性，这些额外的属性又不确定
有三种方法：
- 第一：通过类型断言的方式;(as)
```js
interface SquareConfig {
    color?: string;
    width?: number;
}

function createSquare(config: SquareConfig): { color: string; area: number } {
    // ...
}

let mySquare = createSquare({ width: 100, opacity: 0.5 } as SquareConfig);

```

- 第二：添加字符串索引签名（最佳）

```js
interface SquareConfig {
    color?: string;
    width?: number;
    [propName: string]: any;
}
```

意思是 `SquareConfig` 可以有任意数量属性，并且只要它们不是color和width，那么就无所谓它们的类型是什么。

- 第三：赋值新变量

```js
let squareOptions = { colour: "red", width: 100 };
let mySquare = createSquare(squareOptions);
```
将这个对象赋值给一个另一个变量： 因为 squareOptions不会经过额外属性检查，所以编译器不会报错。

#### 继承类型

一个类型可以继承多个类型，使用 extends

```js
interface Shape {
    color: string;
}

interface PenStroke {
    penWidth: number;
}

interface Square extends Shape, PenStroke {
    sideLength: number;
}

let square = <Square>{};
square.color = "blue";
square.sideLength = 10;
square.penWidth = 5.0;
```

#### 混合类型

一个对象可以同时做为函数和对象使用，并带有额外的属性。
```js
interface Counter {
    (start: number): string;
    interval: number;
    reset(): void;
}

function getCounter(): Counter {
    let counter = <Counter>function (start: number) { };
    counter.interval = 123;
    counter.reset = function () { };
    return counter;
}

let c = getCounter();
c(10);
c.reset();
c.interval = 5.0;
```