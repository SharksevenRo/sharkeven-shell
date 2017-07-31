#!/bin/bash
# git 同步脚本 1 自动跟踪分支提交 2 一键git status git diff 3 自动获取远程库配置 修改用户配置 4 回滚 git add 功能

RED_COLOR='\033[31m'  #红
GREEN_COLOR='\033[32m' #绿
YELOW_COLOR='\033[34m' #黄
RES='\033[0m'

branch=$(git branch | grep '*' | awk '{print $2}')
if [ ! -n $branch ]; then

    git branch --set-upstream-to=origin/$branch
    git branch --unset-upstream master
fi
git status
git diff
str=$(git remote -v | awk '{print $2}' | head -1 | awk '/^*github.com*/ {print $1}')
if [ ! -z "${str}" ]
then
    echo -e "${YELOW_COLOR} remote ${RES} ${GREEN_COLOR} github ${RES} ${RED_COLOR} ${branch} ${RES}"
    git config --global user.name "SharksevenRo"
    git config --global user.email "937257166@qq.com"
else
    echo -e "${YELOW_COLOR} remote ${RES} ${GREEN_COLOR} huanleguang ${RES} ${RED_COLOR} ${branch} ${RES}"
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
