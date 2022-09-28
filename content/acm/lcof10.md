---
title: 🎉|LeetOffer10|斐波那契数列
date: 2022-09-27 07:13:09
tags: [算法]
categories: []
summary: 动态规划

---



> 难度：Easy

#### 题目I

写一个函数，输入 n ，求斐波那契（Fibonacci）数列的第 n 项（即 F(N)）。斐波那契数列的定义如下：

F(0) = 0,   F(1) = 1
F(N) = F(N - 1) + F(N - 2), 其中 N > 1.
斐波那契数列由 0 和 1 开始，之后的斐波那契数就是由之前的两数相加而得出。

答案需要取模 1e9+7（1000000007），如计算初始结果为：1000000008，请返回 1。

 

示例 1：

输入：n = 2
输出：1

#### 代码实现

```c++
class Solution {
public:
    int fib(int n) {
        int a = 0,b = 1,sum = 0;
        if(n == 1)
            return 1;
        for(int i = 0;i < n - 1;i ++){
            sum = (a % 1000000007 + b % 1000000007) % 1000000007;
            a = b;
            b = sum;
        }
        return sum;
    }
};
```

