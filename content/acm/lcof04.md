---
title: 🎉|LeetOffer04|二维数组中的查找
date: 2022-09-26 07:13:06
tags: [算法]
categories: []
summary: 多维二分查找


---



> 难度：Medium🤔

#### 题目

在一个 n * m 的二维数组中，每一行都按照从左到右递增的顺序排序，每一列都按照从上到下递增的顺序排序。请完成一个高效的函数，输入这样的一个二维数组和一个整数，判断数组中是否含有该整数。

 

示例:

现有矩阵 matrix 如下：

[
  [1,   4,  7, 11, 15],
  [2,   5,  8, 12, 19],
  [3,   6,  9, 16, 22],
  [10, 13, 14, 17, 24],
  [18, 21, 23, 26, 30]
]
给定 target = 5，返回 true。

给定 target = 20，返回 false。

限制：

0 <= n <= 1000

0 <= m <= 1000

#### 代码实现

```c++
#include <bits/stdc++.h>
#include <algorithm>
using namespace std;

class Solution {
private:
    int matrixLowerBound(vector<vector<int>>& matrix, int target){
        int n = matrix.size();
        if(n >= 1 && n >= matrix[0].size())
            n = matrix[0].size();
        if(n == 0)
            return -1;
        int l = 0, r = n - 1;
        while(l < r){
            int mid = l + r >> 1;
            if(matrix[mid][mid] >= target)
                r = mid;
            else
                l = mid + 1;
        }
        return l;
    }

    int lowerBound(vector<int>& arr,int target,int n){
        int l = 0, r = n - 1;
        while(l < r){
            int mid = l + r >> 1;
            if(arr[mid] >= target)
                r = mid;
            else
                l = mid + 1;
        }
        return l;
    }

    int colLowerBound(vector<vector<int>>& matrix, int target,int col){
        int n = matrix.size();
        int l = 0, r = n - 1;
        while(l < r){
            int mid = r + l >> 1;
            if(matrix[mid][col] >= target)
                r = mid;
            else
                l = mid + 1;
        }
        return l;
    }

public:
    bool findNumberIn2DArray(vector<vector<int>>& matrix, int target) {
        int mlb = matrixLowerBound(matrix,target);
        if(mlb == -1)
            return false;
        if(matrix[mlb][mlb] == target)
            return true;
        else{
            cout<<matrix[mlb][mlb]<<endl;
            for(;mlb >= 0;mlb --){
                int rlb = lowerBound(matrix[mlb],target,matrix[mlb].size());
                if(matrix[mlb][rlb] == target)
                    return true;
                int clb = colLowerBound(matrix,target,mlb);
                if(matrix[clb][mlb] == target)
                    return true;
            }
        }
        return false;
    }
};
```
