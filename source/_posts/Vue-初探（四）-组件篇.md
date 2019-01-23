---
title: Vue 初探（四）——— 组件篇
date: 2019-01-22 15:32:20
tags: ['js', 'vue']
---

组件是可复用的 Vue 实例，所以他具有 `new Vue` 接收相同的选项，例如`data`、`computed`、`el`、`wath`等，包括生命周期的钩子等，例外的是`el` 这样的根实例特有的选项。

## 基本规范

#### 组件名称
每个组件都需要给他取一个名字，名字的要求：
1. 有意义。
2. 全部是小写字母。
3. 必须要有一个连字符（为了防止与 HTML 元素冲突）。

> 如果你的定义的组件名称是 kebab-case（例如：`Vue.component('my-component-name', { /* ... */ })`）调用的时候也必须使用 kebab-case ）（例如：`<my-component-name>`）
> 如果你定义的组件名称是 PascalCase （例如：`Vue.component('MyComponentName', { /* ... */ })`），那么你在调用的时候可以可以使用 > kebaba-case 和 PascalCase 两种，（例如：`<my-component-name>` 或者 `<MyComponentName>`）
> 注意：直接在 DOM 中使用只有 kebab-case 是有效的

#### 组件文件名称
组件文件名称要求：
1. 展示类的、无逻辑、无状态的组件全部要以`Base`、`App`、 `V`开头。
2. 单例组件（每个页面只会引用一次，而且不会接收 prop ）例如：Header、Sidebar 这种的，应该以 `The` 开头。
3. 耦合性较高的组件，要有父组件为前缀，例如： TodoList.vue、TodoListItem.vue、TodoListItemButton.vue。
4. 名称的单词顺序：高级别词 + 修饰词，例如： SearchButtonClear.vue、SearchButtonRun.vue、SearchInputQuery.vue。


基本示例：
```js
// 定义一个名为 button-counter 的新组件
Vue.component('button-counter', {
  data: function () {
    return {
      count: 0
    }
  },
  template: '<button v-on:click="count++">You clicked me {{ count }} times.</button>'
})

//  使用组件：
<div id="components-demo">
  <button-counter></button-counter>
  <button-counter></button-counter>
  <button-counter></button-counter>
</div>
```

> 注意：每个组件都是独立维护自己的变量，不会互相干扰


#### data 必须是一个函数

<strong>组件的 `data` 必须是一个 函数</strong>

这条规则的是为了保持每个组件被复用的时候自己管理自己的数据。

```js
// 例如
data: function () {
  return {
    count: 0
  }
}
```

## 注册方式

#### 全局注册

全局注册可以使用在任何新创的 Vue 跟实例（`new Vue`）的模板中

```js
Vue.component('component-a', { /* ... */ })
Vue.component('component-b', { /* ... */ })
Vue.component('component-c', { /* ... */ })

new Vue({ el: '#app' })

```
#### 局部注册

> 局部注册的组件在其子组件中不可用

```js
// 定义组件
var ComponentA = { /* ... */ }
var ComponentB = { /* ... */ }
var ComponentC = { /* ... */ }

// 引用
new Vue({
  el: '#app',
  components: {
    'component-a': ComponentA,
    'component-b': ComponentB
  }
})


// 在ES2015 中可以这么写：
import ComponentA from './ComponentA.vue'

export default {
  components: {
    ComponentA
  },
  // ...
}
```


## Prop

prop 是<b>单项数据流</b>，不允许子组件去修改父组件的状态

#### 定义类型

我们可以在组件中通过 `props` 来定义传入的 prop 数据的类型。任何类型都可以传给 prop

```js
Vue.component('my-component', {
  props: {
    // 基础的类型检查 (`null` 匹配任何类型)
    propA: Number,
    // 多个可能的类型
    propB: [String, Number],
    // 必填的字符串
    propC: {
      type: String,
      required: true
    },
    // 带有默认值的数字
    propD: {
      type: Number,
      default: 100
    },
    // 带有默认值的对象
    propE: {
      type: Object,
      // 对象或数组默认值必须从一个工厂函数获取
      default: function () {
        return { message: 'hello' }
      }
    },
    // 自定义验证函数
    propF: {
      validator: function (value) {
        // 这个值必须匹配下列字符串中的一个
        return ['success', 'warning', 'danger'].indexOf(value) !== -1
      }
    }
  }
})
```

type 可以指定：
1. `String`
2. `Number`
3. `Boolean`
4. `Array`
5. `Object`
6. `Date`
7. `Function`
8. `Symbol`
9. 也可以是构造函数，利用 `instanceof` 来检查确认，具体看[文档组件的类型检查](https://cn.vuejs.org/v2/guide/components-props.html#%E7%B1%BB%E5%9E%8B%E6%A3%80%E6%9F%A5)


#### 动静态的 Prop

静态：（直接传）
```js
<blog-post title="My journey with Vue"></blog-post>
```

动态：（通过 `v-bind` 绑定传变量）
```js
// 动态赋予一个变量的值
<blog-post v-bind:title="post.title"></blog-post>

// 动态赋予一个复杂表达式的值
<blog-post v-bind:title="post.title + ' by ' + post.author.name"></blog-post>
```

其他类型传递也是如上一样的传递方式，他还可以通过 `v-bind` 不带参数的传递整个对象的所有值：
```js
post: {
  id: 1,
  title: 'My Journey with Vue'
}

<blog-post v-bind="post"></blog-post>

// 等价于
<blog-post
  v-bind:id="post.id"
  v-bind:title="post.title"
></blog-post>
```

#### 传递方法

`$emit` 的第二个参数可以传递参数

```js
// 子组件
Vue.component('blog-post', {
  props: ['post'],
  template: `
    <div class="blog-post">
      <h3>{{ post.title }}</h3>
      <button v-on:click="$emit('enlarge-text', 0.1)">
        Enlarge text
      </button>
      <div v-html="post.content"></div>
    </div>
  `
})

// 父组件
new Vue({
  el: '#blog-posts-events-demo',
  data: {
    posts: [/* ... */],
    postFontSize: 1
  }
})
<div id="blog-posts-events-demo">
  <div :style="{ fontSize: postFontSize + 'em' }">
    <blog-post
      v-for="post in posts"
      v-bind:key="post.id"
      v-bind:post="post"
      v-on:enlarge-text="postFontSize += $event"
    ></blog-post>
  </div>
</div>

// 或者 父组件也可以这样定义：
...
<blog-post
  ...
  v-on:enlarge-text="onEnlargeText"
></blog-post>
...
methods: {
  onEnlargeText: function (enlargeAmount) {
    this.postFontSize += enlargeAmount
  }
}
...
```

#### 在组件上使用 `v-model`

在组件上使用 `v-model` 必须将 value 和 input 分开传

例如：
```js
// 子组件
Vue.component('custom-input', {
  props: ['value'],
  template: `
    <input
      v-bind:value="value"
      v-on:input="$emit('input', $event.target.value)"
    >
  `
})

// 父组件
<custom-input
  v-bind:value="searchText"
  v-on:input="searchText = $event"
></custom-input>
```

## 非 Prop

1. 对于绝大多数特性来说，从外部提供给组件的值会替换掉组件内部设置好的值。例如：传入的 `type="text"` 会替换掉内部的 `type="date"`，但是对于 class 和 style 是特殊的，他们会合并起来
2. 如果你不希望组件的根元素继承特性，你可以在组件的选项中设置 `inheritAttrs: false`
例如：
```js
Vue.component('my-component', {
  inheritAttrs: false,
  // ...
})

```