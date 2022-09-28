---
title: 🎉|LeetOffer32|从上到下打印二叉树II-III
date: 2022-09-26 07:13:09
tags: [算法]
categories: []
summary: BFS

---



> 难度：Easy

#### 题目II

从上到下按层打印二叉树，同一层的节点按从左到右的顺序打印，每一层打印到一行。

 

例如:
给定二叉树: [3,9,20,null,null,15,7],

    3
   / \
  9  20
    /  \
   15   7
返回其层次遍历结果：

[
  [3],
  [9,20],
  [15,7]
]




#### 代码实现1（AC）

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
    vector<vector<int>> levelOrder(TreeNode* root) {
        vector<vector<int>> res;
        queue<TreeNode*> que;
        if(root == nullptr)
            return res;
        res.push_back(vector<int>());
        que.push(root);
        TreeNode* flag = new TreeNode(-1);
        que.push(flag);
        while(!que.empty()){
            TreeNode* qf = que.front();
            que.pop();
            if(qf == flag){
                if(que.size() == 0)
                    break;
                res.push_back(vector<int>());
                que.push(flag);
                continue;
            }
            if(qf->left != nullptr)
                que.push(qf->left);
            if(qf->right != nullptr)
                que.push(qf->right);
            res.back().push_back(qf->val);
        }
        return res;
    }
};
```



#### 代码实现2（WA）

- 该实现是计算各层所含node元素的个数。WA是因为总是会多算1-2层。

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
    vector<vector<int>> levelOrder(TreeNode* root) {
        vector<vector<int>> res;
        queue<TreeNode*> que;
        if(root == nullptr)
            return res;
        res.push_back(vector<int>());
        que.push(root);
        int levelEleCnt = 0, levelEleTotal = 1;
        while(!que.empty()){
            TreeNode* qf = que.front();
            que.pop();
            if(qf != nullptr){
                que.push(qf->left);
                que.push(qf->right);
                res.back().push_back(qf->val);
            }
            levelEleCnt ++;
            if(levelEleCnt >= levelEleTotal){
                res.push_back(vector<int>());
                levelEleTotal <<= 1;
                levelEleCnt = 0;
            }
        }
        return res;
    }
};
```

#### 题目III

请实现一个函数按照之字形顺序打印二叉树，即第一行按照从左到右的顺序打印，第二层按照从右到左的顺序打印，第三行再按照从左到右的顺序打印，其他行以此类推。

 

例如:
给定二叉树: [3,9,20,null,null,15,7],

    3
   / \
  9  20
    /  \
   15   7
返回其层次遍历结果：

[
  [3],
  [20,9],
  [15,7]
]


提示：

节点总数 <= 1000
相关标签

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
class Solution {
public:
    vector<vector<int>> levelOrder(TreeNode* root) {
        vector<vector<int>> res;
        queue<TreeNode*> que;
        if(root == nullptr)
            return res;
        res.push_back(vector<int>());
        que.push(root);
        TreeNode* flag = new TreeNode(-1);
        que.push(flag);
        bool toRight = true;
        while(!que.empty()){
            TreeNode* qf = que.front();
            que.pop();
            if(qf == flag){
                if(!toRight)
                    reverse(res.back().begin(),res.back().end());
                if(que.size() == 0)
                    break;
                res.push_back(vector<int>());
                que.push(flag);
                toRight = !toRight;
                continue;
            }
            if(qf->left != nullptr)
                que.push(qf->left);
            if(qf->right != nullptr)
                que.push(qf->right);
            res.back().push_back(qf->val);
        }
        return res;
    }
};
```

