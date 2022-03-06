---
title: 阿里系云产品使用体验📹
date: 2022-03-05 07:13:06
tags: [杂谈]
summary: 买云比氪金还积极（）


---



## 项目

- 域名/云解析DNS、SSL证书申请服务

- OSS对象存储

- 轻量应用服务器

  

## 域名服务/云解析DNS、SSL证书申请服务

#### 介绍

云解析 DNS（Domain Name System，简称DNS） 是一种安全、快速、稳定、可靠的权威DNS解析管理服务。 它能够帮助企业和开发者将易于管理识别的域名转换为计算机用于互连通信的数字IP地址，从而将用户的访问路由到相应的网站或应用服务器。



#### 使用体验

- 我曾在阿里云注册过7个域名。目前主要使用的`a.cupof.beer`域名也是在阿里云注册的。
- 在阿里云注册域名，可以享受备案、解析、CDN、SSL等一条龙服务。



#### 实验：解析一个域名，并配置HTTPS

- 进入阿里云 云解析DNS控制台，添加记录。
  - 在我的项目中，需要把一个域名映射到一个IP上，所以这里采用A记录。
  - 当用户通过DNS服务真正访问到主机，Nginx服务器会根据是用户由哪个域名找来的，来提供相应不同的服务。
- 在SSL证书注册界面，申请证书，并添加身份验证配置。当CA机构批准后，方可下载SSL证书到本地，部署到服务器上即可。
- 在Nginx中，可用如下方式为443端口开启SSL；以我的网站`a.cupof.beer`为例：

```nginx
server {
   listen 443;
   ssl on;
   ssl_certificate （安全原因，这里不予展示）;
   ssl_certificate_key （安全原因，这里不予展示）;
   server_name a.cupof.beer;
   root （安全原因，这里不予展示）;
   
   index index.html index.htm;
    
   location / {
   		try_files $uri /index.html =404;  
   }
```



- 当然不要忘记把80端口跳转到443上，这样用户即便用HTTP访问也不会迷路，就像这样：

```nginx
server {
    listen 80;
    server_name a.cupof.beer;
    rewrite ^(.*)$ https://$host$1 permanent;
}
```



- 如果部署了一个后端项目，并不需要提供网页服务，也可以在任一端口号上开启SSL。方法同上。这样做是有必要的。因为如果前端项目采用了HTTPS，但是后端没有及时升级到HTTPS，Chromium内核的浏览器就会报错，就像CORS Policy那样。



## OSS对象存储

#### 介绍

阿里云对象存储OSS（Object Storage Service）是一款海量、安全、低成本、高可靠的云存储服务，提供99.9999999999%(12个9)的数据持久性，99.995%的数据可用性。多种存储类型供选择，全面优化存储成本。



#### 使用体验

- 我买OSS对象存储主要是看中了它方便快捷的对象管理服务。
- 例如我要开设一个网站，上面的静态资源如何实现稳定托管？一般的网页资源，诸如html、css、js文件，不需要单独存储，但是涉及到较大的文件，例如图片、视频、甚至任何形式的文件，如果还托管到自己的后端服务器，就会导致效率低下，如果出现多用户访问的情况，甚至会造成卡顿。
- OSS可以提供一个高并发、高可用、高安全性的对象存储服务，这样当用户需要访问上述静态资源的时候，就可以去OSS那里拿取，而不是来麻烦我这个孱弱的后端服务器了。



#### 实验：上传静态资源，并生成资源定位符（URI）





## 轻量应用服务器

#### 介绍

- 轻量应用服务器 （Simple Application Server，是可快速搭建且易于管理的轻量级云服务器；提供基于单台服务器的应用部署，安全管理，运维监控等服务，一站式提升您的服务器使用体验和效率。
- 轻量应用服务器提供应用镜像和系统镜像可选（总计22款），可以满足不同的应用需求。



#### 使用体验

- 轻量应用服务器相对ECS弹性云而言，更偏向于项目的快速部署与应用。它可以预装不同的镜像，从原生Linux到Docker都可以装。
- 轻量应用服务器也是采用了云计算思想，在购买和配置时可以选择不同的vCPU、vRAM等，根据需要自行配置，非常方便。



#### 实验：部署前后端项目到轻量应用服务器

###### 实现git自动部署、shell自动化后的部署方式

前端先npm run build，把build复制到本地仓库，push一下，前端就部署完成。

后端直接push，然后到服务器上运行一下**nestoKillBack.sh** ，把老的后端杀掉，然后再运行**nestoRunBack.sh** ，编译并开启新后端。

###### shell语法注意

定义变量

```
pid=`ps aux|grep dbdback|grep -v "grep"|awk '{print $2}'`
```

注意，变量和等于号之间不能有空格，否则识别成指令。

使用变量

```
echo ${pid}
```

注意，要加dollar。



###### 如何解决sh脚本不能动态变更工作目录的问题

因为sh是在子进程中运行，其继承了父进程的路径。

解决方案：

把./script.sh运行方法，改成sh ./script即可。

如果还嫌麻烦，可以建立一个script.sh，其中写入“sh ./work.sh一行代码”（work里面是带有cd的），然后去执行./scrpit.sh，也能达到一样的效果。

根本在于，要直接用shell去运行，而不是直接"./"。

###### linux的三类权限

- owner:属主 u
- group:属组 g
- other:其他 o

注意，在多用户的情况下，如果要正常操作，一般要修改other。

###### 搭建git仓库

为了安全，新建git用户，并设置密码

```
useradd git
passwd git
```

可以在git用户的家中建立一个.git目录，作为仓库文件夹：

```
cd ～
mkdir nesto.git
```

进入它，初始化为空仓库：

```
cd nesto.git
git init --bare .
```

允许被push：

```
git config receive.denyCurrentBranch ignore
```

###### 测试git仓库

先把本地仓库添加该remote：

```
git remote add dep git@111.111.111.111:/home/git/nestob.git
```

111.111.111.111是服务器ip。

dep是该远程配置的名称，可以随意指定。

该操作的范围只是更改本仓库。

然后就可以push了：

```
git push -u dep master
```

###### 利用git hook来实现自动部署

git hook就像react hook一样，会在特定的事件发生时执行一定的操作。这里是sh脚本。

进入hooks存放目录：

```
cd /home/git/nestob.git/hooks
```

创建post-receive钩子，使收到push后可以自动拉取代码到服务器的项目目录：

```
vi post-receive
```

写入：

```
#!/bin/bash
git --work-tree=/home/website/wwwroot checkout -f
```

**然后记得授予可执行权限：**

```
chmod +x post-receive
```

这样做的效果就是，当接收到push，就会自动把代码拉取到/home/website/wwwroot目录下。相当于完成了自动部署。

对于go语言一类的需要在目标机器上编译再运行的，还可以在此进行自动编译。

**需要注意，一定要保证git用户拥有对/home/website/wwwroot的写权限！！！**

#### nginx配置

###### 文件目录

nginx文件安装完成之后的文件位置：

- /usr/sbin/nginx：主程序
- /etc/nginx：存放配置文件
- /usr/share/nginx：存放静态文件
- /var/log/nginx：存放日志

###### nginx使用

```
systemctl start nginx.service  //开启
systemctl enable nginx.service  //开机自启动
nginx -t # 查看nginx状态
nginx -s reload # 重新载入配置文件
nginx -s reopen # 重启 Nginx
#上述可能在做了大的操作后不管用，可以使用
#service nginx restart
#进行系统级重启，如果还是不行就重启服务器。
nginx -s stop # 停止 Nginx
```

1.打开 /etc/nginx/conf.d/文件夹，创建配置文件xxx.conf，内容如下：

```
server {
   server_name nesto.cupof.beer;
   root /home/lighthouse/nesto/build;
   index index.html index.htm;
   location / {
   try_files $uri /index.html =404;
   }
}
```

3.配置完成后重新启动nginx

```
service nginx restart
```

在本地npm build，在build文件夹内全选并打包tar.gz，使用sz上传到nginx中配置的项目目录下，原地解压即可。

#### Go项目部署

###### 如何部署

远程服务器先安装go环境。

把本地整个gopath内的所有文件（例如/home/linton/go下的）打包tar.gz，上传到服务器的gopath下，解压。之所以这么做，是为了方便依赖的配置。这样就把所有需要的依赖都打包好了。

注意还可以打开服务器上的gomodule和服务器上的gomodule代理：

```
go env -w GOPROXY=https://goproxy.io,direct
go env -w export GO111MODULE=on
```

然后，在项目目录的src下，编译：

```
go build main.go
```

运行一下测试看看好不好用：

```
./main
```

以后可以放到后台运行：

```
nohup ./main &
```

然后不管是否是当前终端，都可以如下方式查看：

```
ps -aux|grep main
```

如果要杀掉进程，可以kill -9：

```
kill -9  进程号
```

#### react部署

###### 创建生产环境打包

```
npm run build
```



