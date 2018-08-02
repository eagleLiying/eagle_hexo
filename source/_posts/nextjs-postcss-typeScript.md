---
title: nextjs + postcss + typeScript
date: 2018-08-01 10:11:31
tags: ['nextjs', 'js', 'css']
---

## nextjs + typescript + jest + postcss
从零开始配置项目

在 github 上 nextjs 的源码中，有集成好的 [examples](https://github.com/zeit/next.js/tree/canary/examples)，在使用过程中可以直接拿来做参考。

## 一、 nextjs + typeScript

[nextjs 官网](https://nextjs.org/)中有 nextjs 使用的文档，配置 ts 的方法有两种，

#### 1. 使用 [with-jest-typescript](https://github.com/zeit/next.js/tree/canary/examples/with-jest-typescript)

使用 `create-next-app`，通过 `yarn` 或者 `npx` 进行安装。

```js
$ npx create-next-app --example with-jest-typescript with-jest-typescript-app
# 或者
$ yarn create-next-app --example with-jest-typescript with-jest-typescript-app
```

运行以上指令直接拷贝出一份已经集成好的 ts + jest 模板

#### 2. 自己配置（未实践）

1. 根据[官网文档](https://nextjs.org/docs/#setup)的 Getting Start 进行初始化项目
2. 安装 ts ，添加 ts 相关配置。
3. 安装 jest，添加 jest 相关配置。

配置完之后：next.config.js 文件为：
```js
const withTypescript = require('@zeit/next-typescript')

module.exports = withTypescript()
```

## 二、配置 css

1. 安装 `@zeit/next-css`

```js
$ npm install --save @zeit/next-css
# or
$ yarn add @zeit/next-css
```

2. 引入编译后的 css 文件

项目运行之后的 css 文件会编译到 `.next/static/style.css`，我们需要在 `_document.js` 引入这个 css 文件 `/_next/static/style.css`

例如：
```jsx
// ./pages/_document.js
import Document, { Head, Main, NextScript } from 'next/document'

class MyDocument extends Document {
  render() {
    return (
      <html>
        <Head>
          <link rel="stylesheet" href="/_next/static/style.css" />
        </Head>
        <body>
          <Main />
          <NextScript />
        </body>
      </html>
    )
  }
}

export default MyDocument;
```

3. 配置 css 解析

在 next.config.js 文件中配置 css 解析。

```js
const withTypescript = require('@zeit/next-typescript')
const withCSS = require('@zeit/next-css')

module.exports = withTypescript(withCSS())
```

此时在每个项目中的 css 文件都可以正常编译和引入，但是没有模块化和类名编译，

例如：

```jsx
// css 文件 style.css
.example {
  color: red;
}

// pages 页面 pages/index.js
import "../style.css"

export default () => <div className="example">Hello World!</div>

```

4. css modules

配置 css 模块化之后，每个模块编译之后的类名都是全局唯一的：

```jsx
// next.config.js
const withTypescript = require('@zeit/next-typescript')
const withCSS = require('@zeit/next-css')

module.exports = withTypescript(withCSS({
  cssModules: true
}))
```

例如：

```jsx
// css 文件 style.css
.example {
  color: red;
}
// 编译后的类名
._2Qh9GEqcE104osQujlJkZw {
  color: red;
}

// pages 页面 pages/index.js
import style from "../style.css"

export default () => <div className={style.example}>Hello World!</div>

```

5. 优化 css-loader 配置

 `css-loader` 的配置可以通过属性 `cssLoaderOptions` 添加一些其他的配置。

 ```js
 // next.config.js
const withTypescript = require('@zeit/next-typescript')
const withCSS = require('@zeit/next-css')

module.exports = withTypescript(withCSS({
  cssModules: true
  cssLoaderOptions: {
    // 0 => no loaders (default); 1 => postcss-loader; 2 => postcss-loader, sass-loader
    importLoaders: 1,  

    // 指定编译类名方式为：模块名 + 类名 + 随机编码
    localIdentName: '[name]-[local]-[hash:base64:5]',
  }
}))
 ```

 例如：

```jsx
// css 文件 style.css
.example {
  color: red;
}
// 编译后的类名
.style-example-2Qh9G {
  color: red;
}

// pages 页面 pages/index.js
import style from "../style.css"

export default () => <div className={style.example}>Hello World!</div>
```

## 三、配置 postcss

创建 postcss.config.js 文件：

```js
// 例如
module.exports = {
  plugins: {
    // Illustrational
    'postcss-css-variables': {}
  }
}
```

配置 postcss 解析：

 ```js
 // next.config.js
const withTypescript = require('@zeit/next-typescript')
const withCSS = require('@zeit/next-css')

module.exports = withTypescript(withCSS({
  cssModules: true
  cssLoaderOptions: {
    // 0 => no loaders (default); 1 => postcss-loader; 2 => postcss-loader, sass-loader
    importLoaders: 1,  

    // 指定编译类名方式为：模块名 + 类名 + 随机编码
    localIdentName: '[name]-[local]-[hash:base64:5]',
  },
  postcssLoaderOptions: {
    parser: true,
    config: {
      ctx: {
        theme: JSON.stringify(process.env.REACT_APP_THEME)
      }
    }
  }
}))
 ```

## 四、图片的加载

#### 方法一
通过 webpack 配置进行图片解析：

 ```js
 // next.config.js
const withTypescript = require('@zeit/next-typescript')
const withCSS = require('@zeit/next-css')

module.exports = withTypescript(withCSS({
  cssModules: true
  cssLoaderOptions: {
    // 0 => no loaders (default); 1 => postcss-loader; 2 => postcss-loader, sass-loader
    importLoaders: 1,  

    // 指定编译类名方式为：模块名 + 类名 + 随机编码
    localIdentName: '[name]-[local]-[hash:base64:5]',
  },
  postcssLoaderOptions: {
    parser: true,
    config: {
      ctx: {
        theme: JSON.stringify(process.env.REACT_APP_THEME)
      }
    }
  }
  webpack(config) {
        config.module.rules.push(
            { test: /\.(png|jpeg|svg|jpg|gif|eot|ttf|woff)$/, loader: 'url-loader' }
        )
        return config;
    }
}))
 ```

#### 方法二
使用 [next-images](https://github.com/arefaslani/next-images)（未实践）

具体配置方法请参考官网

## 五、遇到的问题

问题： 根据以上配置，最后会遇到一个问题，在 node_modules 里的 css 文件在项目执行时被编译打包，导致使用的第三方组件样式混乱。

解决方案： 官方所处的 postcss 配置不能指定编译的路径，所以最后舍弃使用官方提供的 css 打包编译方式，使用原声的 webpack 配置解析 postcss。配置如下：

```jsx
const withTypescript = require('@zeit/next-typescript');
const withCSS = require('@zeit/next-css');
const ForkTsCheckerWebpackPlugin = require('fork-ts-checker-webpack-plugin');
const StylelintPlugin = require('stylelint-webpack-plugin');
const webpack = require('webpack');
const path = require('path');

module.exports = withTypescript({
  webpack(config, options) {
    const { dev, isServer } = options;

    // Do not run type checking twice:
    if (!isServer) {
      config.plugins.push(
        new ForkTsCheckerWebpackPlugin({
          tslint: true,
        }),
        new StylelintPlugin({
          files: '**/*.{ts,tsx}',
          emitErrors: !dev,
        }),
      );
    }
    // 图片处理
    config.module.rules.push({
      test: /\.(png|jpeg|svg|jpg|gif|eot|ttf|woff)$/,
      loader: 'url-loader',
    });
    // css 处理
    config.module.rules.push({
      oneOf: [
        {
          test: /\.(css|less|styl|scss|sass|sss)$/,
          exclude: path.resolve(__dirname, './src'),
          use: [
            isServer
              ? require.resolve('isomorphic-style-loader')
              : require.resolve('style-loader'),
            // Process external/third-party styles
            {
              loader: 'css-loader',
              options: {
                sourceMap: true,
                minimize: false,
                discardComments: { removeAll: true },
              },
            },
            {
              loader: require.resolve('postcss-loader'),
              options: {
                config: {
                  path: require.resolve('./postcss.config'),
                },
              },
            },
          ],
        },
        {
          test: /\.(css|less|styl|scss|sass|sss)$/,
          include: path.resolve(__dirname, './src'),
          use: [
            isServer
              ? require.resolve('isomorphic-style-loader')
              : require.resolve('style-loader'),
            {
              loader: require.resolve('typings-for-css-modules-loader'),
              options: {
                modules: true,
                importLoaders: 1,
                sourcemap: true,
                localIdentName: '[name]-[local]-[hash:base64:5]',
                discardComments: { removeAll: true },
                namedExport: true,
                camelCase: true,
              },
            },
            {
              loader: require.resolve('postcss-loader'),
              options: {
                config: {
                  path: require.resolve('./postcss.config'),
                },
              },
            },
          ],
        },
      ],
    });

    return config;
  },
});

```

注意：原本只是使用 [style-loader](https://github.com/webpack-contrib/style-loader) 解析 css ，但是存在服务器端渲染问题，会报错：window is undefined。通过查询最后我们选择了 [isomorphic-style-loader](https://github.com/kriasoft/isomorphic-style-loader) 进行服务器端渲染的 css 解析。

## 参考链接

1. [nextjs 官网链接](https://nextjs.org/)
2. [nextjs github 地址](https://github.com/zeit/next.js)
3. [next-plugins](https://github.com/zeit/next-plugins)
4. [next-images](https://github.com/arefaslani/next-images)
5. [css-loader](https://github.com/webpack-contrib/css-loader)
6. [style-loader](https://github.com/webpack-contrib/style-loader)
7. [isomorphic-style-loader](https://github.com/kriasoft/isomorphic-style-loader)
8. [next.js/examples](https://github.com/zeit/next.js/tree/canary/examples)