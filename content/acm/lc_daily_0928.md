---
title: 🎟|LeetCode每日一题|第 k 个数
date: 2022-09-27 07:20:09
tags: [算法]
categories: []
summary: 动态规划或堆

---



> 难度：Mid

#### 题目

有些数的素因子只有 3，5，7，请设计一个算法找出第 k 个数。注意，不是必须有这些素因子，而是必须不包含其他的素因子。例如，前几个数按顺序应该是 1，3，5，7，9，15，21。

示例 1:

输入: k = 5

输出: 9

#### 思路（动态规划）

- 首先注意，既然只是包含3、5、7的质因子，那么一个这样的魔数只能是若干个3、5、7乘起来的，即形如：

$$
3^a5^b7^c
$$

- 状态定义：`dp[i]`代表第i个这样的数字。
- 设置p1、p2、p3三个指针，同时对dp表的元素进行枚举（从1号开始，每次的步长是1）。
- p1满足`dp[p1]*3`是一个这样的数字。p2、p3分别是乘5或7.
- 我们要求第k个最小的这样的数字，所以三种情况都可能是候选人，取最小的那个。假设`dp[p1]*3`被选了，那么`dp[p1]`乘3这种情况就枚举过了，p1++即可。这样一来，p1、p2、p3往往指向不同的元素，分别乘3、乘5、乘7来构成下一个可能的魔数。

#### 思路（堆与集合）

- 重申一遍：任何魔数都是其他魔数乘3、乘5或乘7得到的。
- 秉持这个思想，维护一个装有魔数的堆即可，如果它是最小堆，并且一直在往里添加比堆顶更大的魔数，就可以一直枚举下去，且可以轻松枚举得到第k小的这样的数。
- 问题：可能存在重复值。这个时候可以在pop的时候用set来校验是否出现重复。

#### 代码实现（动态规划）

```c++
#include <bits/stdc++.h>
using namespace std;

class Solution {
    int dp[10010];
public:
    int getKthMagicNumber(int k) {
        int p1 = 1,p2 = 1,p3 = 1;
        memset(dp,0,sizeof(dp));
        dp[1] = 1;
        for(int i = 2;i <= k;i ++){
            dp[i] = min(dp[p1] * 3 ,min(dp[p2] * 5,dp[p3] * 7));
            if(dp[i] == dp[p1] * 3)
                p1 ++;
            if(dp[i] == dp[p2] * 5)
                p2 ++;
            if(dp[i] == dp[p3] * 7)
                p3 ++;
        }
        return dp[k];
    }
};
```



#### 代码实现（堆与集合）

```c++
#include <bits/stdc++.h>
using namespace std;

class Solution {
    priority_queue<long long,vector<long long>, greater<long long>> hp;
    set<long long> st;
public:
    long long getKthMagicNumber(long long k) {
       hp.push(1);
       long long res = 1;
       for(long long i = 1;i <= k;i ++){
           do{
                res = hp.top();
                hp.pop();
           }while(st.count(res));
           st.insert(res);
           hp.push(res * 3);
           hp.push(res * 5);
           hp.push(res * 7);
       }
       return res;
    }
};
```

