---
title: 🎉|LeetOffer32|从上到下打印二叉树
date: 2022-09-26 07:13:08
tags: [算法]
categories: []
summary: BFS

---



> 难度：Easy

#### 题目

从上到下打印出二叉树的每个节点，同一层的节点按照从左到右的顺序打印。

 

例如:
给定二叉树: [3,9,20,null,null,15,7],

    3
   / \
  9  20
    /  \
   15   7
返回：

[3,9,20,15,7]


提示：

节点总数 <= 1000

#### 代码实现

```c++
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode(int x) : val(x), left(NULL), right(NULL) {}
 * };
 */

#include <bits/stdc++.h>
using namespace std;

class Solution {
public:
    vector<int> levelOrder(TreeNode* root) {
        vector<int> res;
        queue<TreeNode*> que;
        if(root == nullptr)
            return res;
        que.push(root);
        while(!que.empty()){
            TreeNode* qf = que.front();
            que.pop();
            if(qf->left != nullptr)
                que.push(qf->left);
            if(qf->right != nullptr)
                que.push(qf->right);
            res.push_back(qf->val);
        }
        return res;
    }
};
```
