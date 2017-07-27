#!/bin/bash
if [ ! -n $1 ]; then

    git branch --set-upstream-to=origin/$1
    git branch --unset-upstream master
fi
git status
git diff
git config --global user.name "xiongmao"
echo "please enter commit info："

read msg

git pull origin $1

git add .
git commit -a -m "$msg"
git push -u origin $1
