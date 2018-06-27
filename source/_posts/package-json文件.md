---
title: package.json 文件
date: 2018-06-17 22:52:04
tags: package.json
categories: json
---

一般每个项目的更目录都会有一个 package.json 文件，定义这个项目所需要的模块以及项目的配置信息，通过执行 ` npm install ` 会根据这个配置文件自动下载所需模块。

### name

项目的名字

规则：
 1. 该名称必须小于或等于214个字符。
 2. 名称不能以点或下划线开头。
 3. 新包名称中不能包含大写字母。
 4. 该名称最终成为URL的一部分，命令行中的参数以及文件夹名称。因此，该名称不能包含任何非URL安全字符。

技巧
 1. 不要使用与核心节点模块相同的名称。
 2. 不要在名称中加入“js”或“node”。假设它是js，因为你正在编写一个package.json文件，并且你可以使用“engines”字段来指定引擎。（见下文。）
 3. 这个名字可能会作为require（）的参数传递，所以它应该是简短的，但也是合理的描述。
 4. 你可能想要检查npm注册表，看看是否已经有这个名称的东西，然后你才会太依附它。[https://www.npmjs.com/](https://www.npmjs.com/)

 名称可以有选择地以范围作为前缀，例如@myorg/mypackage。查看 [npm-scope](https://docs.npmjs.com/misc/scope)查看更多

### description

在其中添加说明。这是一个字符串。这有助于人们发现您的包，因为它已列入 npm search

### version

如果你打算发布你的软件包，package.json 中最重要的东西就是它们所需的名称和版本字段。名称和版本一起构成一个假定为完全唯一的标识符。对软件包所做的更改应该随着对版本的更改而发生变化。如果您不打算发布您的软件包，则名称和版本字段是可选的。

版本必须可以由 [node-semver](https://docs.npmjs.com/misc/semver) 解析

### keywords

把关键字放在里面。这是一串字符串。这有助于人们发现您的包，因为它已列入npm search。

### homepage

项目首页的网址

### bugs

如果项目有问题，可以提交的问题的邮箱和 url。
例如：
```
{ "url" : "https://github.com/owner/project/issues",
  "email" : "project@hostname.com"
}
```

可以指定一个值或者两个值，如果只提供 url ,就不需要指定为对象，而是字符串，并且会被 ` npm bugs ` 命令使用。

### license

项目包的许可证，可以让别人知道你的项目包的限制。[查看详情](https://docs.npmjs.com/files/package.json)

### people fields: author, contributors  

author 是一个人，contributors 是一群人。人具有 url 和 email 。

### files

"files"属性的值是一个数组，内容是模块下文件名或者文件夹名，如果是文件夹名，则文件夹下所有的文件也会被包含进来（除非文件被另一些配置排除了）
你也可以在模块根目录下创建一个".npmignore"文件（windows下无法直接创建以"."开头的文件，使用linux命令行工具创建如git bash），写在这个文件里边的文件即便被写在files属性里边也会被排除在外，这个文件的写法".gitignore"类似。

容易被忽略的文件：
.git
CVS
.svn
.hg
.lock-wscript
.wafpickle-N
.*.swp
.DS_Store
._*
npm-debug.log
.npmrc
node_modules
config.gypi
*.orig
package-lock.json （改用shrinkwrap）

### main

程序的主要入口，这应该是相对于包文件夹根目录的模块ID。

### browser

如果您的模块用于客户端，则应使用浏览器字段而不是主字段。这有助于提示用户可能依赖于 Node.js 模块中不可用的基元。（例如window）

### bin

很多模块有一个或多个需要配置到PATH路径下的可执行模块，npm让这个工作变得十分简单（实际上npm本身也是通过bin属性安装为一个可执行命令的）
如果要用npm的这个功能，在package.json里边配置一个bin属性。bin属性是一个已命令名称为key，本地文件名称为value的map如下：

例如：
```
{ "bin" : { "myapp" : "./cli.js" } }
```

模块安装的时候，若是全局安装，则 npm 会为 bin 中配置的文件在 bin 目录下创建一个软连接（对于 windows 系统，默认会在 C:\Users\username\AppData\Roaming\npm目录下），若是局部安装，则会在项目内的 ./node_modules/.bin/ 目录下创建一个软链接。
如果你的模块只有一个可执行文件，并且它的命令名称和模块名称一样，你可以只写一个字符串来代替上面那种配置，例如：
```
{ 
    "name": "my-program",
    "version": "1.2.5",
    "bin": "./path/to/program",
}
```

### man

制定一个或通过数组制定一些文件来让 linux 下的 man 命令查找文档地址。
如果只有一个文件被指定的话，安装后直接使用 man+ 模块名称，而不管 man 指定的文件的实际名称。例如:

```
{ 
    "name" : "foo",
    "version" : "1.2.3",
    "description" : "A packaged foo fooer for fooing foos",
    "main" : "foo.js",
    "man" : "./man/doc.1"
}
```

通过 man foo 命令会得到 ./man/doc.1 文件的内容。
如果 man 文件名称不是以模块名称开头的，安装的时候会给加上模块名称前缀。因此，下面这段配置：

```
{ 
    "name" : "foo",
    "version" : "1.2.3",
    "description" : "A packaged foo fooer for fooing foos",
    "main" : "foo.js",
    "man" : [ "./man/foo.1", "./man/bar.1" ]
}
```

会创建一些文件来作为 man foo 和 man foo-bar 命令的结果。
man文件必须以数字结尾，或者如果被压缩了，以.gz结尾。数字表示文件将被安装到man的哪个部分。

```
{ 
    "name" : "foo",
    "version" : "1.2.3",
    "description" : "A packaged foo fooer for fooing foos",
    "main" : "foo.js",
    "man" : [ "./man/foo.1", "./man/foo.2" ]
}
```

会创建 man foo 和 man 2 foo 两条命令。

### directories

CommonJs 通过 directories 来制定一些方法来描述模块的结构，看看 npm 的 package.json 文件 https://registry.npmjs.org/npm/latest ，可以发现里边有这个字段的内容。
目前这个配置没有任何作用。

directories.lib
告诉用户模块中 lib 目录在哪，这个配置目前没有任何作用，但是对使用模块的人来说是一个很有用的信息。

directories.bin
如果你在这里指定了 bin 目录，这个配置下面的文件会被加入到bin路径下，如果你已经在 package.json 中配置了 bin 目录，那么这里的配置将不起任何作用。

directories.man
指定一个目录，目录里边都是man文件，这是一种配置 man 文件的语法糖。

directories.doc
在这个目录里边放一些 markdown 文件，可能最终有一天它们会被友好的展现出来（应该是在 npm 的网站上）

directories.example
放一些示例脚本，或许某一天会有用 - -！

### repository

代码库所在地址，对要贡献的人有帮助。如果 git repo 位于 GitHub上 ，那么该 ` npm docs ` 命令将能够找到你的项目

例如：
```
"repository" :
  { 
      "type" : "git",
      "url" : "https://github.com/npm/npm.git"
  }

"repository" :
  { 
    "type" : "svn",
    "url" : "https://v8.googlecode.com/svn/trunk/"
  }
```

该URL应该是一个公开可用的（也许是只读的）url，可以直接传递给VCS程序而无需任何修改。它不应该是你放入浏览器的html项目页面的网址。

对于GitHub，GitHub gist，Bitbucket或GitLab存储库，您可以使用相同的快捷键语法

### scripts

“scripts”属性是一个包含脚本命令的字典，这些脚本命令在包的生命周期中的不同时间运行。关键是生命周期事件，值是在该点运行的命令。
[npm-scripts 查看更多](https://docs.npmjs.com/misc/scripts)

### config

用来设置一些项目不怎么变化的项目配置，例如port等。
用户用的时候可以使用如下用法：
```
http.createServer(...).listen(process.env.npm_package_config_port) 
```

可以通过npm config set foo:port 80来修改config:
```
{ 
    "name" : "foo",
    "config" : { "port" : "8080" }
}
```

### dependencies 和 devDependencies

dependencies 字段指定了项目运行所依赖的模块，devDependencies 指定项目开发所需要的模块。
它们都指向一个对象。该对象的各个成员，分别由模块名和对应的版本要求组成，表示依赖的模块及其版本范围。
对应的版本可以加上各种限定，主要有以下几种：

指定版本：比如 1.2.2，遵循“大版本.次要版本.小版本”的格式规定，安装时只安装指定版本。
> 1. 波浪号（tilde）+指定版本：比如~1.2.2，表示安装1.2.x的最新版本（不低于1.2.2），但是不安装1.3.x，也就是说安装时不改变大版本号和次要版本号。
> 
> 2. 插入号（caret）+指定版本：比如ˆ1.2.2，表示安装1.x.x的最新版本（不低于1.2.2），但是不安装2.x.x，也就是说安装时不改变大版本号。需要注意的是，如果大版本号为0，则插入号的行为与波浪号相同，这是因为此时处于开发阶段，即使是次要版本号变动，也可能带来程序的不兼容。
> 
> 3. latest：安装最新版本。

package.json 文件可以手工编写，也可以使用 ` npm init ` 命令自动生成。项目名称（name）和项目版本（version）是必填的

通过指令安装：
```
$ npm install express --save
$ npm install express --save-dev
```

` --save ` 参数表示将该模块写入 dependencies 属性
` --save-dev ` 表示将该模块写入 devDependencies 属性。

### peerDependencies

有时，你的项目和所依赖的模块，都会同时依赖另一个模块，但是所依赖的版本不一样。比如，你的项目依赖 A 模块和 B 模块的 1.0 版，而A模块本身又依赖 B 模块的 2.0 版。

大多数情况下，这不构成问题，B 模块的两个版本可以并存，同时运行。但是，有一种情况，会出现问题，就是这种依赖关系将暴露给用户。

最典型的场景就是插件，比如 A 模块是 B 模块的插件。用户安装的 B 模块是 1.0 版本，但是 A 插件只能和 2.0 版本的 B 模块一起使用。这时，用户要是将 1.0 版本的B的实例传给 A，就会出现问题。因此，需要一种机制，在模板安装的时候提醒用户，如果 A 和 B 一起安装，那么 B 必须是 2.0 模块。

peerDependencies 字段，就是用来供插件指定其所需要的主工具的版本。

例如：
```
{
  "name": "tea-latte",
  "version": "1.3.5",
  "peerDependencies": {
    "tea": "2.x"
  }
}
```

这可确保您的软件包tea-latte只能与主机软件包的第二个主要版本一起安装tea。npm install tea-latte可能会产生以下依赖关系图：
```
├── tea-latte@1.3.5
└── tea@2.2.0
```

注意：如果 npm 版本1 和 版本2 peerDependencies 不依赖于依赖关系树中的更高版本，它将自动安装。在下一个主要版本的 npm（npm @ 3 ）中，这将不再是这种情况。您将收到警告，指出 peerDependency 未安装。npms 1 ＆ 2 中的行为经常令人困惑，并且很容易让你陷入依赖地狱， npm 旨在尽可能地避免这种情况。

### preferGlobal

preferGlobal的值是布尔值，表示当用户不将该模块安装为全局模块时（即不用–global参数），要不要显示警告，表示该模块的本意就是安装为全局模块。

### style

style指定供浏览器使用时，样式文件所在的位置。样式文件打包工具parcelify，通过它知道样式文件的打包位置。