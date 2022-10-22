---
title: 🎉|LeetOffer47|礼物的最大价值
date: 2022-09-27 07:22:09
tags: [算法]
categories: []
summary: 区间DP

---



> 难度：Mid

#### 题目

在一个 m*n 的棋盘的每一格都放有一个礼物，每个礼物都有一定的价值（价值大于 0）。你可以从棋盘的左上角开始拿格子里的礼物，并每次向右或者向下移动一格、直到到达棋盘的右下角。给定一个棋盘及其上面的礼物的价值，请计算你最多能拿到多少价值的礼物？

 

示例 1:

输入: 
[
  [1,3,1],
  [1,5,1],
  [4,2,1]
]
输出: 12
解释: 路径 1→3→5→2→1 可以拿到最多价值的礼物

#### 思路（MaxDP）

- 初始化：由于只能向右或向下走，所以第1行的dp元素都只能是由第1行的其他元素算出，所以第1列的dp元素都只能是由第1列的其他元素算出。
- 状态定义：`dp[i][j]`即到i,j点为止的最大礼物数量。状态转移：因为只能向右或者向下，所以考虑对左边、上面的dp元素取max。

#### 代码实现

```c++
#include <bits/stdc++.h>
using namespace std;

class Solution {
    int dp[205][205];
public:
    int maxValue(vector<vector<int>>& grid) {
        memset(dp,0,sizeof(dp));
        dp[0][0] = grid[0][0];
        for(int i = 1;i < grid.size();i ++)
            dp[i][0] = grid[i][0] + dp[i - 1][0];
        for(int i = 1;i < grid[0].size();i ++)
            dp[0][i] = grid[0][i] + dp[0][i - 1];
        for(int i = 1;i < grid.size();i ++)
            for(int j = 1; j < grid[0].size(); j ++){
                dp[i][j] = max(dp[i][j-1],dp[i-1][j]) + grid[i][j];
            }
        return dp[grid.size() - 1][grid[0].size() - 1];
    }
};
```

