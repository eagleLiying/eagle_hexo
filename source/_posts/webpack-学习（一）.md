---
title: webpack 学习（一）
date: 2018-09-15 11:12:04
tags: webpack
---

## webpack 是做什么的

1. 围绕 webpack 的工具体系能够帮助我们系统化的解决前端资源问题
2. 涵盖项目开发（单页应用或多页应用）、组件开发、SDK 开发等不同需求
3. 配置从简到繁，需要结合项目需求和工具配置构建出符合项目的工作流。不仅仅是工具，更需要结合工程化的思想。

官网地址: [中文地址](https://webpack.docschina.org/)   [英文地址](https://webpack.js.org/)

> 主要需要注意的是所看 webpack 的版本，因为每个版本有很多不一样的地方

## 基本原理

#### 1. 初始化

自动构建，读取与合并参数，加载 plugin，实例化 complier plugin 机制，在这个环节可以通过配置 plugin 对 webpack 进行自定义功能扩展
（简言之：使用 plugin 加载各种插件）

#### 2. 编译

从 entry 出发，针对每一个 module 调用 loader 翻译文件内容，并找到 module 的依赖进行编译处理。
（简言之：使用 loader 配置加载编译项目内容）

#### 3. 输出

将编译后的 module 组合成 chunk , 将 chunk 转换成文件，输出到文件系统。
（简言之：将编译后的文件输出）

注释：chunk 中文意思为 块

## 核心概念

配置 webpack 首先需要了解主要有哪些核心的配置：

```jsx
const config = {
    mode: "",           // string  构建模式, eg: production(default)、development、none
    context: "",        // 上下文
    entry: "",          // 入口，可以是字符串、数组、对象、函数
    devtool: "",        // 开发工具
    output: { },        // 输出配置
    module: { },        // module 配置，处理不同资源
    plugins: [ ],       // plugin 配置
    optimization: { },  // 资源优化配置项
    devServer: { }      // webpack-dev-server 服务配置
}
```

## 区分构建环境

#### 分离多套环境

单独配置，可以解决很多问题

1. 分离坏境：
    dev（开发环境）、 prod（线上环境）、 staging（预发布环境）、 test（测试环境）
2. 多环境配置文件放在 build
3. 抽取 base 公共配置
4. webpack-merge 合并配置
5. 全局环境参数通过 env.mode 传入

#### 不同环境不同配置

- 区分环境不同的 mode 构建模式
- 区分环境不同的 output.filename
- 定义全局环境变量：webpack/lib/DefinePlugin  实现逻辑层也能按环境区分
- 区分环境配置不同的 CDN && publicpath

![](/images/webpack/env1.png)![](/images/webpack/env2.png)![](/images/webpack/env3.png)

## loader

#### 使用 loader 配置更多资源：
1. url-loader 和 file-loader   ：前者内置后者，实现了图片的 base64 压缩以及资源大小限制、减少 http 请求
2. postcss-loader 使用 postcss 生态，需要在预处理器前配置实用
3. babel-loader  享受了最新的语法特性带来的技术红利

#### 常用的 loader 总结：

##### 文件 
- raw-loader 加载文件原始内容（utf-8）
- val-loader 将代码作为模块执行，并将 exports 转为 JS 代码
- url-loader 像 file loader 一样工作，但如果文件小于限制，可以返回 data URL
- file-loader 将文件发送到输出文件夹，并返回（相对）URL

##### JSON 
- json-loader 加载 JSON 文件（默认包含）
- json5-loader 加载和转译 JSON 5 文件
- cson-loader 加载和转译 CSON 文件

##### 转换编译(Transpiling) 
- script-loader 在全局上下文中执行一次 JavaScript 文件（如在 script 标签），不需要解析
- babel-loader 加载 ES2015+ 代码，然后使用 Babel 转译为 ES5
- buble-loader 使用 Bublé 加载 ES2015+ 代码，并且将代码转译为 ES5
- traceur-loader 加载 ES2015+ 代码，然后使用 Traceur 转译为 ES5
- ts-loader 或 awesome-typescript-loader 像 JavaScript 一样加载 TypeScript 2.0+
- coffee-loader 像 JavaScript 一样加载 CoffeeScript
- fengari-loader 使用 fengari 加载 Lua 代码

##### 模板(Templating) 
- html-loader 导出 HTML 为字符串，需要引用静态资源
- pug-loader 加载 Pug 模板并返回一个函数
- jade-loader 加载 Jade 模板并返回一个函数
- markdown-loader 将 Markdown 转译为 HTML
- react-markdown-loader 使用 markdown-parse parser(解析器) 将 Markdown 编译为 React 组件
- posthtml-loader 使用 PostHTML 加载并转换 HTML 文件
- handlebars-loader 将 Handlebars 转移为 HTML
- markup-inline-loader 将内联的 SVG/MathML 文件转换为 HTML。在应用于图标字体，或将 CSS 动画应用于 SVG 时非常有用。
- twig-loader 编译 Twig 模板，然后返回一个函数

##### 样式 
- style-loader 将模块的导出作为样式添加到 DOM 中
- css-loader 解析 CSS 文件后，使用 import 加载，并且返回 CSS 代码
- less-loader 加载和转译 LESS 文件
- sass-loader 加载和转译 SASS/SCSS 文件
- postcss-loader 使用 PostCSS 加载和转译 CSS/SSS 文件
- stylus-loader 加载和转译 Stylus 文件

#### 常用 loader 简单分类

##### 1. Html/handlebars/Jade：
html-loader、pug-loader、handlebars-loader

##### 2. CSS/Stylus/SASS/LESS
css-loader、sass-loader、less-loader、stylus-loder

##### 3. ESM/AMD/CMD/COMMONJS
babel-loader + presets / plugins

##### 4. Images/IconFont/JSON
url-loader、json-loader


## plugin

#### 常用的 plugin

1. copy-webpack-plugin  将不需要编译的静态资源复制到目标目录
2. html-webpack-plugin   编译 html 模板
3. clean-webpack-plugin   清空指定目标目录资源，例如 dist
4. mini-css-extract-plugin  独立 css 资源，压缩。 extract-text-css-plugin  不兼容 4.x
5. AggressiveSplittingPlugin	将原来的 chunk 分成更小的 chunk
6. BabelMinifyWebpackPlugin	使用 babel-minify 进行压缩
7. BannerPlugin	在每个生成的 chunk 顶部添加 banner
8. CommonsChunkPlugin	提取 chunks 之间共享的通用模块
9. CompressionWebpackPlugin	预先准备的资源压缩版本，使用 Content-Encoding 提供访问服务
10. ContextReplacementPlugin	重写 require 表达式的推断上下文
11. CopyWebpackPlugin	将单个文件或整个目录复制到构建目录
12. DefinePlugin	允许在编译时(compile time)配置的全局常量
13. DllPlugin	为了极大减少构建时间，进行分离打包
14. EnvironmentPlugin	DefinePlugin 中 process.env 键的简写方式。
15. ExtractTextWebpackPlugin	从 bundle 中提取文本（CSS）到单独的文件
16. HotModuleReplacementPlugin	启用模块热替换(Enable Hot Module Replacement - HMR)
17. HtmlWebpackPlugin	简单创建 HTML 文件，用于服务器访问
18. I18nWebpackPlugin	为 bundle 增加国际化支持
19. IgnorePlugin	从 bundle 中排除某些模块
20. LimitChunkCountPlugin	设置 chunk 的最小/最大限制，以微调和控制 chunk
21. LoaderOptionsPlugin	用于从 webpack 1 迁移到 webpack 2
22. MinChunkSizePlugin	确保 chunk 大小超过指定限制
23. MiniCssExtractPlugin	为每个引入 CSS 的 JS 文件创建一个 CSS 文件
24. NoEmitOnErrorsPlugin	在输出阶段时，遇到编译错误跳过
25. NormalModuleReplacementPlugin	替换与正则表达式匹配的资源
26. NpmInstallWebpackPlugin	在开发时自动安装缺少的依赖
27. ProvidePlugin	不必通过 import/require 使用模块
28. SourceMapDevToolPlugin	对 source map 进行更细粒度的控制
29. EvalSourceMapDevToolPlugin	对 eval source map 进行更细粒度的控制

## 优化基本开发体验

#### devtool 开发工具

| #	  | 模式| 解释 | 速度 |	生产环境 |
| --- | --- | --- | --- |
| 1 | eval | 会将模块封装到 eval 里包裹起来执行，并且会在末尾追加注释 //@ sourceURL.	 | 最快 |	不可以|
| 2 | source-map | 生成一个 SourceMap 文件.	 | 很慢 |	可以|
| 3 | hidden-source-map | 和 source-map 一样，但不会在 bundle 末尾追加注释.	 | 很慢 |	可以|
| 4 | inline-source-map | 生成一个 DataUrl 形式的 SourceMap 文件.	 | 很慢 |	不可以|
| 5 | eval-source-map | 每个 module 会通过 eval() 来执行，并且生成一个 DataUrl 形式的 SourceMap .	 | 很慢 |	不可以|
| 6 | cheap-source-map | 生成一个没有列信息（column-mappings）的 SourceMaps 文件，不包含 loader 的 sourcemap（譬如 babel 的 sourcemap）	 | 一般快 |	可以|
| 7 | cheap-module-source-map | 生成一个没有列信息（column-mappings）的 SourceMaps 文件，同时 loader 的 sourcemap 也被简化为只包含对应行的。	 | 较快 |	可以|
| 8 | cheap-module-eval-source-map | 类似 cheap-eval-source-map，并且，在这种情况下，源自 loader 的 source map 会得到更好的处理结果。	 | 较快 |	不可以|

#### proxy 代理

结合 mock 平台实现 proxy 代理。[用友 mock 平台](https://mock.yonyoucloud.com/)

Proxy && Mock

- Webpack-dev-server proxy 配置
- Node server based Koa / Express
- webpack-hot-moddleware
- Http-proxy-middleware
- Http-proxy(node-http-proxy)

配置：
```js
devServer: {
            contentBase: path.resolve(__dirname, '../dist'),
            hot: true,
            proxy: {
                "/corp": {
                    target: "https://mock.yonyoucloud.com/mock/548",
                    secure: false,
                    changeOrigin: true
                }
            }
        },

// 代理服务器会在请求头中加入相应host header，然后目标服务器就可以根据这个 header 来区别要访问的站点
```

#### MHR 热更新

##### 热更新执行过程：

模块更新, 更新的消息冒泡到 entry

1. 未捕获：webpack-dev-server 内置 live reload
2. 捕获：HotModuleReplacementPlugin ——>  webpack de -server （通知更新） <——> （web sokcet 通信）浏览器

##### 配置
1. devServer设置hot: true
2. New webpack.HotModuleReplacementPlugin() 插件设置
3. 入口判断：
```js
if (module.hot) {
   module.hot.accept()
}
```

##### 多端同步更新（移动、桌面、web端）

插件：
browser-sync-webpack-plugin

配置： 
```js
const BrowserSyncPlugin = require('browser-sync-webpack-plugin')

module.exports = {
  // ...
  plugins: [
    new BrowserSyncPlugin({
      // browse to http://localhost:3000/ during development,
      // ./public directory is being served
      host: 'localhost',
      port: 3000,
      server: { baseDir: ['public'] }
    })
  ]
}

```

一直期待已久的整体系统的学习 webpack， 终于有机会了，现在将自己学习的笔记记录下来。。。


