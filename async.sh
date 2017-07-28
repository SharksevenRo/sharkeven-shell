#!/bin/bash
# git 同步脚本 1 自动跟踪分支提交 2 一键git status git diff 3 自动获取远程库配置 修改用户配置 4 回滚 git add 功能
branch=$(git branch | head -1 | awk '{print $1}')
if [ ! -n $branch ]; then
    git branch --set-upstream-to=origin/$branch
fi
git status
git diff
str=$(git remote -v | awk '{print $2}' | head -1 | awk '/^*github.com*/ {print $1}')
if [ ! -z "${str}" ]
then
    echo "github ${branch}"
    git config --global user.name "SharksevenRo"
    git config --global user.email "937257166@qq.com"
else
    echo "huanleguang ${branch}"
    git config --global user.name "xiongmao"
    git config --global user.email "xiongmao@huanleguang.com"
fi

echo "添加提交信息 | Enter 回滚 add "

read msg

if [ ! -z "${msg}" ]
then
    git pull origin $branch

    git add .
    git commit -a -m "$msg"
    git push -u origin $branch
else
        # 撤销提交
        git reset HEAD .

fi
