---
title: “#Apps from beer” 应用中心来了！
date: 2022-02-28 07:15:06
tags: [杂谈]
summary: 来这里看我的项目~


---

#### 更新啦！

全新的App中心上线！

- 添加了搜索框
- 圆角化图片
- 增加多语言支持
- 增加markdown目录
- 优化页面滚动



#### 然而，搜索框无法使用！出现了如下报错！

`This request has been blocked; the content must be served over HTTPS.`

报错的原因就是当前页面是https协议加载的，但是这个页面发起了一个http的ajax请求，这种做法是非法的。HTTPS页面里动态的引入HTTP资源，比如引入一个js文件，会被直接block掉的.在HTTPS页面里通过AJAX的方式请求HTTP资源，也会被直接block掉的。



#### 客户端解决办法

可以在相应的页面的<head>里加上这句代码，意思是自动将http的不安全请求升级为https:

```html
<meta http-equiv="Content-Security-Policy" content="upgrade-insecure-requests">
```



#### 服务器端解决办法

配置一下 Nginx,在nginx location 添加：

```nginx
location / {
           ...
     proxy_set_header X-Forwarded-Proto  $scheme;
}
```

