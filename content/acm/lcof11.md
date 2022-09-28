---
title: 🎉|LeetOffer11|旋转数组的最小数字
date: 2022-09-26 07:13:07
tags: [算法]
categories: []
summary: 条件二分查找


---



> 难度：Medium🤔

#### 题目

把一个数组最开始的若干个元素搬到数组的末尾，我们称之为数组的旋转。

给你一个可能存在 重复 元素值的数组 numbers ，它原来是一个升序排列的数组，并按上述情形进行了一次旋转。请返回旋转数组的最小元素。例如，数组 [3,4,5,1,2] 为 [1,2,3,4,5] 的一次旋转，该数组的最小值为 1。  

注意，数组 [a[0], a[1], a[2], ..., a[n-1]] 旋转一次 的结果为数组 [a[n-1], a[0], a[1], a[2], ..., a[n-2]] 。

 

示例 1：

输入：numbers = [3,4,5,1,2]
输出：1
示例 2：

输入：numbers = [2,2,2,0,1]
输出：0


提示：

n == numbers.length
1 <= n <= 5000
-5000 <= numbers[i] <= 5000
numbers 原来是一个升序排序的数组，并进行了 1 至 n 次旋转

#### 代码实现

```c++
#include <bits/stdc++.h>
using namespace std;

class Solution {
private:
    int isSmaller(vector<int>& arr,int n){
        int l = 0,r = n - 1;
        while(l < r){
            int mid = r + l >> 1;
            if(arr[mid] > arr[r])
                l = mid + 1;
            else if(arr[l] == arr[r]){
                l ++;
                r --;
            }
            else
                r = mid;
        }
        return l;
    }
public:
    int minArray(vector<int>& numbers) {
        int ind = isSmaller(numbers,numbers.size());
        return numbers[ind];
    }
};
```
