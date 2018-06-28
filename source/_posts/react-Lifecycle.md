---
title: React 生命周期详解
date: 2018-06-28 23:25:26
tags: ['react', 'js']
---

## 组件渲染顺序

### 第一次 render

第一次在`客户端`渲染：

1.  getDefaultProps
2.  getInitialState
3.  componentWillMount
4.  render
5.  componentDidMount

第一次在`服务端`渲染

1.  getDefaultProps
2.  getInitialState
3.  componentWillMount
4.  render

componentDidMount 不会在服务端被渲染的过程中调用。
getDefaultProps 相当于 ES6 中 `staticdefaultProps = {}`
getInitialState 相当于 constructor 中的 `this.state = {}`

### Props 改变

1.  componentWillReceiveProps
2.  shouldComponentUpdate
3.  componentWillUpdate
4.  render
5.  componentDidUpdate

### State 改变

1.  shuldComponentDidMount
2.  componentWillUpdate
3.  render
4.  componentDidUpdate

### 组件销毁

1. componentWillUnmount

## 生命周期函数详解

### getDefaultProps

这个方法在组件中只会调用一次，返回的对象可以设置默认的 `props`（properties 的缩写）值。

```jsx
class App extends React.Component {
    getDefaultProps: () => {
        return {
            name: 'pomy',
        }
    };

    render() {
        return (
            <div>
                Hello {this.props.name}
            </div>
        );
    }
}

export default App;

// 在父组件没有传 this.props.name 时。默认输出结果为：Hello pomy
```
### getInitialState

该方法有且只会调用一次，用来初始化每个实例的 state，在这个方法里，可以访问组件的 props，state 与 props 的区别在于 state只存在组件的内部，

> getDefaultPops 是对于组件类来说只调用一次，后续该类的应用都不会被调用。
> getInitialState 是对于每个组件实例来讲都会调用，并且只调一次。


```jsx
class App extends React.Component {
    getInitialState: () => {
        return {liked: false};
    };

    handleClick: () => {
        this.setState({liked: !this.state.liked});
    };
    render() {
    var text = this.state.liked ? 'like' : 'haven\'t liked';
    return (
      <p onClick={this.handleClick}>
        You {text} this. Click to toggle.
      </p>
    );
  }
}

export default App;
```

### componentWillMount

该方法在首次渲染之前调用，也是再 render 方法调用之前修改 state 的最后一次机会。

### render

必需的一个方法，用来表示组件的输出，render方法返回的结果并不是真正的 DOM 元素。

### componentDidMount

该方法在服务端不会被调用，该方法被调用时已经渲染出还是的 DOM ，可以在该方法中使用 window、this.getDOMNode() ，也可以访问到真实的 DOM(推荐使用 ReactDOM.findDOMNode())。

### componentWillReceiveProps

子组件中的 props 被父组件修改是，componentWillReceiveProps 将被调用，可以在这个函数里面根据新的 props 更改 state 引起组件的重新渲染。

### shouldComponentUpdate

该函数是控制在 props 或者 state 发生改变时是否要引起重新渲染，如果直接返回 false 就不会执行 render 方法。一般不会在开发中使用。

### componentWillUpdate

该方法在 props 和 state 即将进行渲染前，componentWillUpdate(object nextProps, object nextState) 会被调用，注意不要在此方面里再去更新 props 或者 state。（容易形成死循环）

### componentDidUpdate

在组件重新被渲染之后，componentDidUpdate(object prevProps, object prevState) 会被调用。可以在这里访问并修改 DOM。

### componentWillUnmount

组件从 DOM 中卸载后被销毁，在 componentDidMount 中添加的任务都需要再该方法中撤销，如创建的定时器或事件监听器。

