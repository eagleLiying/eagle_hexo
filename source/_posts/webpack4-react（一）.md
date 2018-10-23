---
title: webpack4 + react 从零开始（一）
date: 2018-10-16 18:27:06
tags: ['webpack', 'js', 'react']
---
## 创建初始化项目

按照以下指令创建一个空项目：

```js
$ mkdir webpack-project
$ cd webpack-project
$ npm init
```

初始化成功之后会在项目中自动创建一个 package.json 文件

## 安装 webpack4

空项目有了，那我们来安装 webpack

```js
$ npm install webpack  webpack-cli --save-dev

```

在 package.json 文件中加入：

```js
"scripts": {
  "build": "webpack"
}
```

我们来运行一下试试：

```js
$ npm run build
```

发现会报错：
```js
ERROR in Entry module not found: Error: Can't resolve './src' in '~/webpack-project'
```

这是因为我们没有指定 webpack 打包的入口文件，在 webpac4 中我们不再需要手动指定入口文件和出口文件了，默认入口文件为:  `~/src/index.js`，打包后的出口文件为：`~/dist/main.js`

我们创建对应的入口文件之后再次运行 `npm run build`，就可以发现 build 成功了，这就完成了简单的第一步。

### 生产模式和开发模式

一个项目起码应该有：

1. 开发配置文件：定义 webpack 的 dev server 和其他东西
2. 生产配置文件：用来定义UglifyJSPlugin，sourcemap和其他东西


再完成以上简单的第一步后，你会发下控制台会报一个警告：
```js
WARNING in configuration
The 'mode' option has not been set, webpack will fallback to 'production' for this value. Set 'mode' option to 'development' or 'production' to enable defaults for each environment.
You can also set it to 'none' to disable any default behavior. Learn more: https://webpack.js.org/concepts/mode/
```

他的提示就是你需要区分开发环境和生产环境，再 package.json 上加上以下指令：
```js
"scripts": {
  "dev": "webpack --mode development",  // 开发环境的build
  "build": "webpack --mode production"   // 生产环境的build
}
```

现在分别运行：

```js
$ npm run build
$ npm run dev
```

比较最后 build 完的结果可以发现最后两个文件的不同：

1. 生产环境做了一些额外的优化，例如: minification, scope hoisting, tree-shaking等。
2. 开发模式为速度做了优化，除了提供一个没有压缩的包以外没有做额外的事。


### 覆盖默认的入口/出口文件

webpack 4 默认 `~/src/index.js` 和 `~/dist/main.js` 作为入口和出口文件，但是我们也可以修改，如下：

```js
"scripts": {
  "dev": "webpack --mode development ./foo/src/js/index.js --output ./foo/main.js",
  "build": "webpack --mode production ./foo/src/js/index.js --output ./foo/main.js"
}
```

### 用 Babel 转换 ES6 的 js 代码

现在大家都再用 es6 ，但是浏览器还没有完全支持，所以我们需要做一些转换（transpiling）。

这个时候我们就用到了之前文章说过的 `loader`

用到的 loader 有：

- babel-core
- babel-loader
- babel-preset-env （for compiling Javascript ES6 code down to ES5）

```js
npm i babel-core babel-loader babel-preset-env --save-dev
```

安装完成之后在项目的根目录下建立一个 `.babelrc` 文件用来配置 Babel

```js
{
    "presets": [
        "env"
    ]
}
```

配置 Babel 可以有两种方法：

1. 添加 webpack 配置文件
2. 在 package.json  脚本里使用 --module-bind

webpack 4 虽然以零配置为目标，但是并没有完全零配置，我们任然需要使用 `webpack.config.js` 进行扩展配置。


#### 1. 配置 babel-loader

在项目跟目录创建一个 `webpack.config.js` 然后添加如下配置：

```js
module.exports = {
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader"
        }
      }
    ]
  }
};
```

只需要配置自己需要配置的 loader 就可以。

注意 babel-loader 的版本号，@8.x 可能会报错：

```js
Error: Cannot find module '@babel/core'
 babel-loader@8 requires Babel 7.x (the package '@babel/core'). If you'd like to use Babel 6.x ('babel-core'), you should install 'babel-loader@7'.
```

解决办法就是可以安装 @7.x 版本的，本人安装 7.1.5 之后成功 build

build 成功之后去查看 main.js 文件可以发现 es6 的代码已经被转义成 es5 的。

#### 2. 通过 --module-bind 配置

还有一种使用webpack loaders的方法就是 `--module-bind`，你可以在命令行中指定 loaders。

在 webpack 3 中已经有了这个选项。

可以在 package.json 文件中添加如下配置：

```js
"scripts": {
    "dev": "webpack --mode development --module-bind js=babel-loader",
    "build": "webpack --mode production --module-bind js=babel-loader"
}

```

虽然这个方法还不错，但是我还是觉都不是很好，个人不喜欢太长的执行脚本指令。

## 配置 React

首先就是安装：

```js
$ npm i react react-dom --save-dev
```

添加 `babel-preset-react`

```js
$ npm i babel-preset-react --save-dev
```

在 `.bablerc` 文件中添加配置：

```js
{
    "presets": [
        "env",
        "react"
    ]
}
```

同时也可以在 webpcak.config.js 中添加 `*.jsx` 文件的加载配置：

```js
module.exports = {
  module: {
    rules: [
      {
        test: /\.(js|jsx)$/,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader"
        }
      }
    ]
  }
};
```

测试是否安装成功：

在 `~/src/App.js` 里创建一个 React 组件:

```js
import React from "react";
import ReactDOM from "react-dom";
const App = () => {
  return (
    <div>
      <p>React here!</p>
    </div>
  );
};
export default App;
ReactDOM.render(<App />, document.getElementById("app"));
```

然后在 `~/src/index.js` 中引入：

```js
import App from "./App";
```

重新构建，查看结果

## HTML 插件

项目中需要加载 html 文件的话，需要用到：[html-webpack-plugin](https://github.com/jantimon/html-webpack-plugin) 和 [html-loader](https://github.com/webpack-contrib/html-loader)

安装依赖项：
```js
$ npm i html-webpack-plugin html-loader --save-dev
```
在 webpack.config.js 中添加配置项：

```js
const HtmlWebPackPlugin = require("html-webpack-plugin");
module.exports = {
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader"
        }
      },
      {
        test: /\.html$/,
        use: [
          {
            loader: "html-loader",
            options: { minimize: true }
          }
        ]
      }
    ]
  },
  plugins: [
    new HtmlWebPackPlugin({
      template: "./src/index.html",
      filename: "./index.html"
    })
  ]
};
```

新建 `~/src/index.html` html 文件：

```js
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>webpack 4 quickstart</title>
</head>
<body>
    <div id="app">
    </div>
</body>
</html>
```

重新构建，发现在 dist 文件中新加了 index.html 文件，并且在该文件中引入了 main.js ，
在浏览器中打开 index.html ，发现可以看到有组件 `App.js` 中的 “React here!”。

`html-webpack-plugin` 常用的参数解释：
```js
options = {
    template: path.join(__dirname, 'default_index.ejs'),  // 本地模板文件的位置，支持加载器(如handlebars、ejs、undersore、html等)
    filename: 'index.html',  // 要输出的文件名字，默认为 index.html
    favicon: false,  // 添加特定favicon路径到输出的html文档中
}
```

filename：
1. filename配置的html文件目录是相对于webpackConfig.output.path路径而言的，不是相对于当前项目目录结构的。
2. 指定生成的html文件内容中的 `link` 和` script ` 路径是相对于生成目录下的，写路径的时候请写生成目录下的相对路径。

template：
1. template配置项在html文件使用file-loader时，其所指定的位置找不到，导致生成的html文件内容不是期望的内容。
2. 为template指定的模板文件没有指定任何loader的话，默认使用ejs-loader。如template: './index.html'，若没有为.html指定任何loader就使用ejs-loader

## CSS 提取

之前 webpack 使用 extract-text-webpack-plugin 提取 css，但是他在 webpack4 中不是很好的支持，所以我们使用 [`mini-css-extract-plugin`](https://github.com/webpack-contrib/mini-css-extract-plugin)  

安装：

```js
$ npm i mini-css-extract-plugin css-loader --save-dev
```

> 提示：你需要把webpack升级到4.2.0.0，不然这个插件无法运行！

添加配置：

```js
const HtmlWebPackPlugin = require("html-webpack-plugin");
+ const MiniCssExtractPlugin = require("mini-css-extract-plugin");

module.exports = {
    module: {
        rules: [
            ...
+            {
+               test: /\.css$/,
+                use: [MiniCssExtractPlugin.loader, "css-loader"]
+            }
        ]
    },
    plugins: [
        ...
+        new MiniCssExtractPlugin({
+            filename: "[name].css",
+           chunkFilename: "[id].css"
+        })
      ]
};
```

新建一个 `~/src/index.css` 文件：

```js
body {
    background-color: red;
}
```

在入口文件中引入 css 文件：

```js
import style from "./index.css";
```

重新构建，查看 css，并且在 index.html 文件中已经注入了 css 文件

## 配置 webpack dev server

webpack dev server 主要有两个功能：
1. 在浏览器中加载你的 app
2. 自带热更新

安装：

```js
$ npm i webpack-dev-server --save-dev
```

添加启动脚本：

```js
"scripts": {
    ...
  "start": "webpack-dev-server --mode development --open",
}
```

执行：
```js
$ npm run start 
```

在浏览器中会自动启动 `http://localhost:8080/`

## 参考连接：

[html-loader](https://github.com/webpack-contrib/html-loader)

[html-webpack-plugin](https://github.com/jantimon/html-webpack-plugin)

[https://juejin.im/post/5af934806fb9a07ab458bced](https://juejin.im/post/5af934806fb9a07ab458bced)
