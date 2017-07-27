#!/bin/bash
# 自动跟踪分支 asyc 分支名 自动定位远程库 切换不同用户配置
if [ ! -n $1 ]; then

    git branch --set-upstream-to=origin/$1
    git branch --unset-upstream master
fi
git status
git diff
str=$(git remote -v | awk '{print $2}' | head -1 | awk '/^*github.com*/ {print $1}')
if [ ! -z "${str}" ]
then
    git config --global user.name "SharksevenRo"
    git config --global user.email "937257166@qq.com"
else
    git config --global user.name "xiongmao"
    git config --global user.email "xiongmao@huanleguang.com"
fi

echo "please enter commit info："

read msg

git pull origin $1

git add .
git commit -a -m "$msg"
git push -u origin $1
