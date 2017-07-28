#!/bin/bash
if [ ! -n $1 ]; then

    git branch --set-upstream-to=origin/$1
    git branch --unset-upstream master
fi
git status
git diff
str=$(git remote -v | awk '{print $2}' | head -1 | awk '/^*github.com*/ {print $1}')
if [ ! -z "${str}" ]
then
    echo 'github'
    git config --global user.name "SharksevenRo"
    git config --global user.email "937257166@qq.com"
else
    echo 'huanleguang'
    git config --global user.name "xiongmao"
    git config --global user.email "xiongmao@huanleguang.com"
fi

echo "添加提交信息 | Enter 回滚 add "

read msg

if [ ! -z "${msg}" ]
then
    git pull origin $1

    git add .
    git commit -a -m "$msg"
    git push -u origin $1
else
        # 撤销提交
        git reset HEAD .

fi
