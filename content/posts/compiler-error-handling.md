---
title: 做个编译器——错误处理与恢复
date: 2022-05-23 15:13:06
tags: [笔记]
categories: []
summary: 程序可能会出现很多错误，他们只能由不同的模块发现，并进行处理。



---



## General

程序可能会出现很多错误，他们只能由不同的模块发现，并进行处理。例如词法分析器无法发现嵌套错误。

<img src="https://linton-pics.oss-cn-beijing.aliyuncs.com/uPic/image-20220610172109122.png" alt="image-20220610172109122" style="zoom:33%;" />
