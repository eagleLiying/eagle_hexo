---
title: BOM-DOM
date: 2018-06-28 01:01:59
tags: html
---

## BOM

1. BOM 是 Browser Object Model 的缩写，即浏览器对象模型。

BOM 和浏览器关系密切。浏览器的很多东西可以通过 JavaScript 控制的，例如打开新窗口、打开新选项卡（标签页）、关闭页面，把网页设为主页，或加入收藏夹，等这些涉及到的对象就是 BOM。

2. BOM没有相关标准

由于没有标准，不同的浏览器实现同一功能，可以需要不同的实现方式。虽然 BOM 没有一套标准，但是各个浏览器的常用功能的 JavaScript 代码还是大同小异的，对于常用的功能实际上已经有默认的标准了。

3. BOM 的最根本对象是 window。

## DOM

1. DOM 是 Document Object Model 的缩写，即文档对象模型。

DOM 和文档有关，这里的文档指的是网页，也就是 HTML 文档。网页是由服务器发送给客户端浏览器的，无论用什么浏览器，接收到的 HTML 都是一样的，所以 DOM 和浏览器无关，它关注的是网页本身的内容。由于和浏览器关系不大，所以标准就好定了。

2. DOM 是 W3C 的标准。

3. DOM 最根本对象是 document（window.document）。DOM 的最根本的对象是 BOM 的 window 对象的子对象。

## BOM DOM 关系图

![](/images/bom-dom.jpg)


原文链接：https://blog.csdn.net/xiao__gui/article/details/8315148