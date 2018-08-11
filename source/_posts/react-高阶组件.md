---
title: react-高阶组件（HOC）
date: 2018-08-09 18:43:09
tags: ['js', 'react']
---
使用 react 很久了，也使用 react 高阶组件很多次了，但是总也没有特别清楚的去总结一下高阶组件，现在终于有时间总结如下：


## 是什么
高阶组件就是一个函数，且该函数接受一个组件作为参数，并返回一个新的组件。
对比组件将props属性转变成UI，高阶组件则是将一个组件转换成另一个新组件。

例如 [`Redux`](https://redux.js.org/) 的 `connect` 方法，就是典型的高阶组件。

## 做什么

[react 官方文档](https://doc.react-china.org/docs/higher-order-components.html)上说是解决交叉问题的。
直白了说就是解决了同一个数据在不同组件中渲染的问题

详细了说：

```jsx
class CommentList extends React.Component {
  constructor() {
    super();
    this.handleChange = this.handleChange.bind(this);
    this.state = {
      // "DataSource" 就是全局的数据源
      comments: DataSource.getComments()
    };
  }

  componentDidMount() {
    // 添加事件处理函数订阅数据
    DataSource.addChangeListener(this.handleChange);
  }

  componentWillUnmount() {
    // 清除事件处理函数
    DataSource.removeChangeListener(this.handleChange);
  }

  handleChange() {
    // 任何时候数据发生改变就更新组件
    this.setState({
      comments: DataSource.getComments()
    });
  }

  render() {
    return (
      <div>
        {this.state.comments.map((comment) => (
          <Comment comment={comment} key={comment.id} />
        ))}
      </div>
    );
  }
}
```
```jsx
class BlogPost extends React.Component {
  constructor(props) {
    super(props);
    this.handleChange = this.handleChange.bind(this);
    this.state = {
      blogPost: DataSource.getBlogPost(props.id)
    };
  }

  componentDidMount() {
    DataSource.addChangeListener(this.handleChange);
  }

  componentWillUnmount() {
    DataSource.removeChangeListener(this.handleChange);
  }

  handleChange() {
    this.setState({
      blogPost: DataSource.getBlogPost(this.props.id)
    });
  }

  render() {
    return <TextBlock text={this.state.blogPost} />;
  }
}
```

以上两个组件 `CommentList` 和 `BlogPost` 都调用了 `DataSource` 的不同方法获取数据，渲染出不同的结果。但是整体相同的路由有：
1. 挂载组件时， 向 DataSource 添加一个监听函数。
2. 在监听函数内， 每当数据源发生变化，都是调用 setState函数设置新数据。
3. 卸载组件时， 移除监听函数。

高阶组件的精华就是：
在一个大型应用中，在 `DataSource` 中获取数据，通过 `setState` 模式修改的情况会发生好多次，这个时候我们就可以抽象出一个模式，该模式允许我们在同一个地方写一个逻辑，在多个组件中都能使用。

所以我们是使用高级组件解决以上例子为：
```jsx
// 函数接受一个组件参数……
function withSubscription(WrappedComponent, selectData) {
    // WrappedComponent: 包裹的组件
    // selectData: 组件中需要修改的数据
  // ……返回另一个新组件……
  return class extends React.Component {
    constructor(props) {
      super(props);
      this.handleChange = this.handleChange.bind(this);
      this.state = {
        data: selectData(DataSource, props)
      };
    }

    componentDidMount() {
      // ……注意订阅数据……
      DataSource.addChangeListener(this.handleChange);
    }

    componentWillUnmount() {
      DataSource.removeChangeListener(this.handleChange);
    }

    handleChange() {
      this.setState({
        data: selectData(DataSource, this.props)
      });
    }

    render() {
      // ……使用最新的数据渲染组件
      // 注意此处将已有的props属性传递给原组件
      return <WrappedComponent data={this.state.data} {...this.props} />;
    }
  };
}
```
```jsx
const CommentListWithSubscription = withSubscription(
  CommentList,
  (DataSource) => DataSource.getComments()
);

const BlogPostWithSubscription = withSubscription(
  BlogPost,
  (DataSource, props) => DataSource.getBlogPost(props.id)
);
```

> 注意：高阶组件既不会修改原组件，也不会使用继承复制原组件的行为。相反，高阶组件是通过将原组件包裹（wrapping）在容器组件（container component）里面的方式来 组合（composes） 使用原组件。高阶组件就是一个没有副作用的纯函数。

包裹组件不关心数据是如何被使用的，你可以在 `withSubscription` 中添加任何参数进行更多的配置，包裹组件和 `withSubscription` 之间的传递也完全是通过 `props` 传递的。

## 注意点

不要在高阶组件内部修改（或以其它方式修改）原组件的原型属性。
如下的错误事例：
```jsx
function logProps(InputComponent) {
  InputComponent.prototype.componentWillReceiveProps(nextProps) {
    console.log('Current props: ', this.props);
    console.log('Next props: ', nextProps);
  }
  // 我们返回的原始组件实际上已经
  // 被修改了。
  return InputComponent;
}

// EnhancedComponent会记录下所有的props属性
const EnhancedComponent = logProps(InputComponent);
```

问题：
1. input组件不能够脱离增强型组件（enhanced component）被重用。（复用性底）
2. 如果你用另一个高阶组件来转变 EnhancedComponent ，同样的也去改变 componentWillReceiveProps 函数时，第一个高阶组件（即EnhancedComponent）转换的功能就会被覆盖。

正确的写法：
```jsx
function logProps(WrappedComponent) {
  return class extends React.Component {
    componentWillReceiveProps(nextProps) {
      console.log('Current props: ', this.props);
      console.log('Next props: ', nextProps);
    }
    render() {
      // 用容器组件组合包裹组件且不修改包裹组件，这才是正确的打开方式。
      return <WrappedComponent {...this.props} />;
    }
  }
}
```

优点：
1. 复用性高，可以重复使用。

综上总结：高阶组件就是容器组件的一部分，也可以认为高阶组件就是参数化的容器组件定义

## 约定

### 1. 不传不相关的 props

高阶组件应该传递与它要实现的功能点无关的props属性。

例如：
```js
render() {
  // 过滤掉与高阶函数功能相关的props属性，
  // 不再传递
  const { extraProp, ...passThroughProps } = this.props;

  // 向包裹组件注入props属性，一般都是高阶组件的state状态
  // 或实例方法
  const injectedProp = someStateOrInstanceMethod;

  // 向包裹组件传递props属性
  return (
    <WrappedComponent
      injectedProp={injectedProp}
      {...passThroughProps}
    />
  );
}
```

原因：确保高阶组件最大程度的 灵活性 和 可重用性。

### 2. 最大化使用组合

并不是所有的高阶组件看起来都是一样的。有时，它们仅仅接收一个参数，即包裹组件：

```js
const NavbarWithRouter = withRouter(Navbar);
```

一般而言，高阶组件会接收额外的参数。例如 Relay 的一个例子：

```jsx
const CommentWithRelay = Relay.createContainer(Comment, config);
```

我们常用的 `redux` 的 `connect` 就是一个很典型的例子
```jsx
// React Redux's `connect`
const ConnectedComment = connect(commentSelector, commentActions)(Comment);
```
拨开之后：
```jsx
// connect是一个返回函数的函数（译者注：就是个高阶函数）
const enhance = connect(commentListSelector, commentListActions);
// 返回的函数就是一个高阶组件，该高阶组件返回一个与Redux store
// 关联起来的新组件
const ConnectedComment = enhance(CommentList);
```

拨开之后是不是瞬间清晰了很多，说到底  `connect` 就是一个返回了高阶组件的函数

这种形式有点让人迷惑，有点多余，但是它有一个有用的属性。那就是，类似 connect 函数返回的单参数的高阶组件有着这样的签名格式， `Component => Component` .输入和输出类型相同的函数是很容易组合在一起。

```js
// 不要这样做……
const EnhancedComponent = withRouter(connect(commentSelector)(WrappedComponent))

// ……你可以使用一个功能组合工具
// compose(f, g, h) 和 (...args) => f(g(h(...args)))是一样的
const enhance = compose(
  // 这些都是单参数的高阶组件
  withRouter,
  connect(commentSelector)
)
const EnhancedComponent = enhance(WrappedComponent)
```

同样做法发还有 [`lodash`](https://lodash.com/docs/#flowRight) 和 [` Ramda`](https://ramdajs.com/docs/#compose) 他们均有 `compose` 这种组合函数。


### 3. 包装显示名字以便于调试

我们一般给高阶组件起名字都是 `with*`，例如：高阶组件名字`withSubscription` ，包裹组件名字 `CommentList`，使用时为 `WithSubscription(CommentList)`

原因：区分高阶组件和普通组件

## 注意事项

### 1. 不要再render函数中使用高阶组件

```jsx
render() {
  // 每一次render函数调用都会创建一个新的EnhancedComponent实例
  // EnhancedComponent1 !== EnhancedComponent2
  const EnhancedComponent = enhance(MyComponent);
  // 每一次都会使子对象树完全被卸载或移除
  return <EnhancedComponent />;
}
```

如上使用的话问题：
1. 性能问题
2. 重新加载一个组件会引起原有组件的所有状态和子组件丢失。

如果需要动态调用高阶组件，那么可以在组件的构造函数或生命周期函数中调用。

### 2. 必须将静态方法做拷贝

当使用高阶组件时，原始组件呗容器组件包裹之后就会失去原始组件原来的方法。解决这个问题就是需要我们把静态方法全部拷贝。

方法：
1. 使用 [`hoist-non-react-statics`](https://github.com/mridgway/hoist-non-react-statics)

```jsx
import hoistNonReactStatic from 'hoist-non-react-statics';
function enhance(WrappedComponent) {
  class Enhance extends React.Component {/*...*/}
  hoistNonReactStatic(Enhance, WrappedComponent);
  return Enhance;
}
```
2. 分别导出组件自身的静态方法

```jsx
// 替代……
MyComponent.someFunction = someFunction;
export default MyComponent;

// ……分别导出……
export { someFunction };

// ……在要使用的组件中导入
import MyComponent, { someFunction } from './MyComponent.js';
```

### 3. Refs属性不能传递

高阶组件可以传递所有的props属性给包裹的组件，但是不能传递refs引用。
refs是一个伪属性，React对它进行了特殊处理。如果你向一个由高阶组件创建的组件的元素添加ref应用，那么ref指向的是最外层容器组件实例的，而不是包裹组件。

