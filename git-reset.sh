#!/bin/bash
# git 本地和远程回滚提交
#

if [ ! -z "$1" ]
then
    echo "branch $1"
else
    echo "commitID require"
    echo "example: gset branch commitID"
    exit 0
fi
if [ ! -z "$2" ]
then
    echo "commitID $2"
else
    echo "commitID require"
    echo "example: gset branch commitID"
    exit 0
fi
isExit=$(git branch -a | grep $1)
# 判断远程仓库是否存在
if [ ! -z "$isExit" ]
then
    echo "back exit"
else
    echo "remotes origin $1 not exit"
    exit 0
fi
round=$RANDOM
# 判断备份分支是否存在
isExit=$(git branch -a | grep $1_$round)
echo ${isExit}

if [ ! -z "$isExit" ]
then
    echo "back exit"
    round=$RANDOM
else
    # checkout 一个备份分支
    echo "checkout -b $1_$round"
    git checkout -b $1_$round
fi
# 切换到目标分支
git checkout $1

# 在备份上回滚到某个提交
git reset --hard $2
# 删除目标分支
git checkout master
git branch -D $1
git checkout -b $1_$round
# 删除远程仓库目标分支
git push origin :$1
# 在回滚后的备份分支上check以目标分支名新建新分支
git checkout -b $1
