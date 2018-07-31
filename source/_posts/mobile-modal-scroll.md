---
title: mobile-modal-scroll
date: 2018-07-31 11:03:09
tags: ['js', 'css']
categories: js
---

# 移动端滚动穿透解决方案:

移动端当有 fixed 遮罩背景和弹出层时，在屏幕上滑动能够滑动背景下面的内容。

现在总结一下三种解决方案：

### 1. css 之 `overflow: hidden`

当页面弹出 modal 之后，将 `.HTML_MODAL_OPEN` 添加到 `html` 上，并且禁止 html 和 body 的滚动。

```css
.HTML_MODAL_OPEN {
  &, body {
    overflow: hidden;
    height: 100vh;
  }
}
```

缺点：

1. 由于 html 和 body的滚动条都被禁用，弹出层后页面的滚动位置会丢失。
2. 页面的背景还是能够有滚的动的效果

### 2. js 之 preventDefault

添加监听事件：

```js
modal.addEventListener('touchmove', function(e) {
  e.preventDefault();
}, false);
```

缺点：

1. modal 层里不能有其它需要滚动的内容。滚动事件会被一起禁止掉。

### 3. js + css 值 `position: fixed`

参考很多做法，最后发现能完美解决这个问题只有 js 和 css 配合才可以。解决方案如下：

css 部分：

```css
body.BODY_MODAL_OPEN {
    position: fixed;
    width: 100%;
}
```

js 部分：
所以如果需要保持滚动条的位置需要用 js 保存滚动条位置关闭的时候还原滚动位置。

```js
const scrollTop;  // 记录上次的滚动位置

function setDocumentScroll(isShowModal) {
    if (isShowModal) {
      scrollTop = document.scrollingElement.scrollTop;
      document.body.classList.add('BODY_MODAL_OPEN');
      document.body.style.top = -scrollTop + 'px';
      return;
    }

    // modal 隐藏回复 body 的原滚动位置
    document.body.classList.remove('BODY_MODAL_OPEN');
    document.scrollingElement.scrollTop = scrollTop;
    document.body.style.top = '0';
}
```


#### 参考
https://uedsky.com/2016-06/mobile-modal-scroll/