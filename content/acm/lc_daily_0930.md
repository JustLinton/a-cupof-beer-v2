---
title: 🎟|LeetCode每日一题|零矩阵
date: 2022-09-29 07:20:09
tags: [算法]
categories: []
summary: 水题

---



> 难度：Mid

#### 题目



编写一种算法，若M × N矩阵中某个元素为0，则将其所在的行与列清零。 

示例 1：

输入：
[
  [1,1,1],
  [1,0,1],
  [1,1,1]
]
输出：
[
  [1,0,1],
  [0,0,0],
  [1,0,1]
]

{{< button href="https://leetcode.cn/problems/zero-matrix-lcci/" target="_self" >}}
To Question
{{< /button >}}

#### 代码实现

```c++
#include <bits/stdc++.h>
using namespace std;

typedef pair<int,int> Point;

class Solution {
    set<Point> zeroPoints;
public:
    void setZeroes(vector<vector<int>>& matrix) {
        int n = matrix.size(), m = matrix[0].size();
        for(int i = 0;i < n;i ++)
            for(int j = 0;j < m;j ++){
                if(matrix[i][j] == 0)
                    zeroPoints.insert(make_pair(i,j));
            }
        for(Point p : zeroPoints){
            int row = p.first, col = p.second;
            for(int i = 0;i < m;i ++)
                matrix[row][i] = 0;
            for(int i = 0;i < n;i ++)
                matrix[i][col] = 0;
        }
    }
};
```


