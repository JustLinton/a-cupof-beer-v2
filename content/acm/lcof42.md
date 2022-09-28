---
title: 🎉|LeetOffer42|连续子数组的最大和
date: 2022-09-27 07:15:09
tags: [算法]
categories: []
summary: 动态规划

---



> 难度：Mid

#### 题目

输入一个整型数组，数组中的一个或连续多个整数组成一个子数组。求所有子数组的和的最大值。

要求时间复杂度为O(n)。

 

示例1:

输入: nums = [-2,1,-3,4,-1,2,1,-5,4]
输出: 6
解释: 连续子数组 [4,-1,2,1] 的和最大，为 6。


提示：

1 <= arr.length <= 10^5
-100 <= arr[i] <= 100

#### 代码实现

```c++
class Solution {
    int dp[100020];
public:
    int maxSubArray(vector<int>& nums) {
        memset(dp,0,sizeof(dp));
        int res = dp[0] = nums[0];
        for(int i = 1;i < nums.size();i ++){
            if(dp[i - 1] < 0) dp[i] = nums[i];
            else dp[i] = nums[i] + dp[i - 1];
            if(res <= dp[i]) res = dp[i];
        }
        return res;
    }
};
```

