---
title: 🎉|LeetOffer46|把数字翻译成字符串
date: 2022-09-27 07:23:09
tags: [算法]
categories: []
summary: 区间DP

---



> 难度：Mid

#### 题目

给定一个数字，我们按照如下规则把它翻译为字符串：0 翻译成 “a” ，1 翻译成 “b”，……，11 翻译成 “l”，……，25 翻译成 “z”。一个数字可能有多个翻译。请编程实现一个函数，用来计算一个数字有多少种不同的翻译方法。

 

示例 1:

输入: 12258
输出: 5
解释: 12258有5种不同的翻译，分别是"bccfi", "bwfi", "bczi", "mcfi"和"mzi"

#### 技巧

- 函数to_string是头文件string下的方法。它将各种类型的数字转换成string对象返回。**这样一来，就能很方便地以位为单位来处理数字。**在DP中很好用了属于是。
- string对象可以比较大小。类似于strcmp。

#### 思路

- 状态定义：dp[i]即到数字的第i位为止，可以翻译出的种类数。
- 若第i位能和i-1位连起来翻译，那么此时i-2位就不能和i-1位连起来，即种类数和到第i-2位是一样的；若第i位不和i-1位连起来，那种类数和到i-1为止是一样的。

#### 代码实现

```c++
#include <bits/stdc++.h>
using namespace std;

class Solution {
    int dp[40];
public:
    int translateNum(int num) {
        string snum = to_string(num);
        int n = snum.length();
        dp[0] = 1;
        for(int i=1;i<n;i++){
            if (i == 1 && snum.substr(i - 1,2)>="10" && snum.substr(i - 1,2)<="25")
                dp[1] = 2;
            else if(i >= 2 && snum.substr(i - 1,2)>="10" && snum.substr(i - 1,2)<="25")
                dp[i] = dp[i - 2] + dp[i - 1];
            else
                dp[i] = dp[i - 1];
        }
        return dp[n - 1];
    }
};
```

