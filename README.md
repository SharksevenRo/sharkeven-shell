# shell secript init enviroment and server security script

## async.sh git同步脚本
> 根据远程仓库切换用户配置 公司和个人的账户区分 自动新分支跟踪提交，一键git status 和 git diff

### 使用
> 提交/第一次分支同步提交 sh async.sh

## goto.sh 进入工作目录脚本
#### 配置
> 环境变量 WORK_DIR 工作目录<br>
> 环境变量 PERSON_WORK_DIR 个人工作目录根

### 使用
> source goto.sh 到工作目录 <br>
> > source goto.sh p 到个人工作目录 <br>

## docker_expose.sh docker容器端口运行时暴露脚本

### 使用
> sh docker 容器名 宿主端口:容器端口
