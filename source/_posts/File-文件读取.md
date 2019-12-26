---
title: File 文件读取
date: 2019-12-21 14:45:54
tags: "js"
---

## 创建实例

文件读取主要使用：FileReader，FileReader主要用于将文件内容读入内存，通过一系列异步接口可以再主线程中访问本地文件

```js
var reader = new FileReader();
```

## 方法

#### readAsDataURL(file):
异步读取文件内容，结果用data:url的字符串形式表示，主要可以用于前端上传图片预览
![](/images/readFile/readAsDataURL.png)

例如：
```js
var input  = document.getElementById("file");   // input file
input.onchange = function(){
    var file = this.files[0];
        if(!!file){
            var reader = new FileReader();
            // 图片文件转换为base64
            reader.readAsDataURL(file);
            reader.onload = function(){
                // 显示图片
                document.getElementById("file_img").src = this.result;
        }
    }
}

```


#### readAsText(file,encoding):
异步按字符读取文件内容，结果用字符串形式表示,此方法可以通过不同的编码方式读取字符，例如：utf-8读取

readAsText读取文件的单位是字符，故对于文本文件，只要按规定的编码方式读取即可；
而对于媒体文件（图片、音频、视频），其内部组成并不是按字符排列，故采用readAsText读取，会产生乱码，同时也不是最理想的读取文件的方式

直接打开图片看内容为：
![](/images/readFile/readAsTextImage.png)
用readAsText 读取之后：
![](/images/readFile/readAsTextImageText.png)


#### readAsBinaryString(file):
异步按字节读取文件内容，结果为文件的二进制串

直接打开图片看内容为：
![](/images/readFile/readAsBinaryStringSource.png)
用readAsBinaryString 读取之后：
![](/images/readFile/readAsBinaryStringText.png)

与readAsText不同的是，readAsBinaryString函数会按字节读取文件内容。
然而诸如0101的二进制数据只能被机器识别，若想对外可见，还是需要进行一次编码，而readAsBinaryString的结果就是读取二进制并编码后的内容。
尽管readAsBinaryString方法可以按字节读取文件，但由于读取后的内容被编码为字符，大小会受到影响，故不适合直接传输，也不推荐使用。
如：图片文件原大小为6764 字节，而通过readAsBinaryString读取后，内容被扩充到10092个字节

#### readAsArrayBuffer(file)
异步按字节读取文件内容，结果用ArrayBuffer对象表示

与readAsBinaryString类似，readAsArrayBuffer方法会按字节读取文件内容，并转换为ArrayBuffer对象。
我们可以关注下文件读取后大小，与原文件大小一致。
这也就是readAsArrayBuffer与readAsBinaryString方法的区别，readAsArrayBuffer读取文件后，会在内存中创建一个ArrayBuffer对象（二进制缓冲区），将二进制数据存放在其中。通过此方式，我们可以直接在网络中传输二进制内容。

#### abort

终止读取文件操作


## 参考
[https://www.cnblogs.com/dongxixi/p/11005607.html](https://www.cnblogs.com/dongxixi/p/11005607.html)
[https://developer.mozilla.org/zh-CN/docs/Web/API/FileReader](https://developer.mozilla.org/zh-CN/docs/Web/API/FileReader)