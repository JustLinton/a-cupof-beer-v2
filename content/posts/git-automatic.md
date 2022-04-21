---
title: git自动化初探🚀
date: 2022-04-20 07:13:07
tags: [技术]
summary: 在服务器上做nachos的最佳选择！


---



### 搭建git仓库

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

###### 测试git仓库[#](https://a.cupof.beer/posts/how-to-deploy-your-web-project-on-a-server/#测试git仓库)

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

###### 利用git hook来实现自动部署[#](https://a.cupof.beer/posts/how-to-deploy-your-web-project-on-a-server/#利用git-hook来实现自动部署)

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
git --work-tree=/home/admin/nachos/code/lab5_git checkout -f
```

**然后记得授予可执行权限：**

```
chmod +x post-receive
```

这样做的效果就是，当接收到push，就会自动把代码拉取到/home/website/wwwroot目录下。相当于完成了自动部署。

对于go语言一类的需要在目标机器上编译再运行的，还可以在此进行自动编译。

**需要注意，一定要保证git用户拥有对/home/website/wwwroot的写权限，也就是将模式修改为777.**

因为一般目录的模式都是`drwxrwxr-x`，第三列是对所有用户的权限，所以改成`drwxrwxrwx`，即777.

```
chmod 777 lab5_git
```

