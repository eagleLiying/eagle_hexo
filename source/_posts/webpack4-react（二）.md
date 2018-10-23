---
title: webpack4 + react 从零开始（二）
date: 2018-10-16 18:27:06
tags: ['webpack', 'js', 'react']
---
## 优化配置 CSS

1. css-loader: 加载 css 文件

2. style-loader: 通过注入 `<style>` 标签到 `html` 模板中 来加载样式。

核心代码：
```js
{
    test: /\.css$/,
    use: [
        { loader: "style-loader" }, 
        { loader: "css-loader" }
    ]
}
```

3. mini-css-extract-plugin： 将 css 文件单独打包编译，并且通过 `<link>` 标签注入 html 文件中。

核心代码：

```js
const MiniCssExtractPlugin = require("mini-css-extract-plugin");

module.exports = {
    module: {
        rules: [
           ...
            {
                test: /\.css$/,
                use: [
                    MiniCssExtractPlugin.loader, 
                    { loader: "css-loader" }
                ]
            }
        ]
    },
    plugins: [
        ...
        new MiniCssExtractPlugin({
            filename: "[name].css",
            chunkFilename: "[id].css"
        }),
    ]
}
```

> 注意： `mini-css-extract-plugin` 和 `style-loader` 是互斥的，只需要保留一种配置方法就就可以。不过我个人喜欢 `style-loader`，这样页面首屏加载慢的话不会样式混乱


至此我们配置文件为：

```js
const HtmlWebPackPlugin = require("html-webpack-plugin");

module.exports = {
    module: {
        rules: [
            {
                test: /\.(js|jsx)$/,
                exclude: /node_modules/,
                use: {
                    loader: "babel-loader"
                }
            },
            {
                test: /\.html$/,
                exclude: /node_modules/,
                use: [
                    {
                        loader: "html-loader",
                        options: { minimize: true }
                    }
                ]
            },
            {
                test: /\.css$/,
                exclude: /node_modules/,
                use: [
                    { loader: "style-loader" }, 
                    { 
                        // https://github.com/webpack-contrib/css-loader
                        loader: "css-loader",
                        options: {
                            modules: true,
                            localIdentName: '[name]-[local]-[hash:base64:5]'
                        }  
                    }
                ]
            }
        ]
    },
    plugins: [
        new HtmlWebPackPlugin({
            favicon:'./src/images/favicon.ico', //favicon路径
            template: "./src/index.html",
            filename: "./index.html"
        }),
    ],
    devServer: {
        port: 5000
    }
};
```

在 css 文件中我们可以这样写：

```js
:local(.aa) { // 本地类名编译
    background: red;
    color: yellow;
  }
  
:local(.bb) {
    composes: aa;  // 导入本文件中整个 aa 类名样式
    background: blue;
}

:global .cc {  // .cc 类名不编译
    font-size: 50px;
}

.gg {
    composes: dd from './components/A.css'; // 导入其他组件 某个类名样式
    color: #ffffff;
}
```

在这里补充一个小点：我还安装了 [`classnames`](https://www.npmjs.com/package/classnames)，这样可以更好的管理多个类名。

## 配置路由

在这里我使用了 react 全家桶中的 [`react-router`](https://github.com/ReactTraining/react-router)

由于我要做的是 web 端页面，所以我安装了 [`react-router-dom`](https://reacttraining.com/react-router/web/guides/quick-start)

在安装 react-router 时，主要需要安装 babel-plugin-syntax-dynamic-import

安装完之后就不需要额外配置什么选项，直接引入按照文档说明就可以使用了。

#### 问题
问题：页面正常显示，但是刷新 /topics/01 或者 /list/:id 这种子组件路由的页面时，404 not found ， 进入/topics 路由时虽然没有组件显示但并不是404.<br />
问题所在:
```js
//不要写这个路径，不要写这个路径，不要写这个路径
<script type="text/javascript" src="main.bundle.js"></script>

//写这个路径，写这个路径，写这个路劲
<script type="text/javascript" src="/main.bundle.js"></script>
```

解决方案：
在 webpack.config.js 中加入如下配置
```

module.exports = {
+    output: {
+        publicPath: '/',
+    },

    ...

    devServer: {
        ...

+        historyApiFallback: true
    },

    ...

};
```
