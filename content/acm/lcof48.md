---
title: 🎉|LeetOffer48|最长不含重复字符的子字符串
date: 2022-09-27 07:26:09
tags: [算法]
categories: []
summary: 区间DP

---



> 难度：Mid

#### 题目

请从字符串中找出一个最长的不包含重复字符的子字符串，计算该最长子字符串的长度。

 

示例 1:

输入: "abcabcbb"
输出: 3 
解释: 因为无重复字符的最长子串是 "abc"，所以其长度为 3。

#### 思路

- 状态定义：dp[i]即以s[i]为结尾的满足题意的最长子串长度。
- 利用另一个指针j线性地向下标缩小的方向探查第一个和s[i]相同字母的位置，其和s[i]之间的距离就是j。
- 判断j和dp[i-1] + 1的大小关系。若前者小于后者，说明重复字符在以i-1结尾的符合要求的子串的内部，否则在其外部。对于前一种情况，取j即可，对于后一种情况，取dp[i-1]+1即可。即取二者的交。

#### 代码实现

```c++
#include <bits/stdc++.h>
using namespace std;

class Solution {
    int dp[40010];

public:
    int lengthOfLongestSubstring(string s) {
        memset(dp,0,sizeof(dp));
        int n = s.length();
        if(n == 0)
            return 0;
        dp[0] = 1;
        int res = 1;
        for(int i=1;i<n;i++){
            int j=1;
            for(;i-j >= 0;j++){
                if(s[i-j]==s[i])break;
            }
            dp[i] = j > dp[i - 1] + 1? dp[i - 1] + 1 : j;
            res = max(res,dp[i]);
        }
        return res;
    }
};
```

