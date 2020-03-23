#!/bin/bash
#################################################
#         Name: init.sh
#     Function: 脚本部署docker-compose
#################################################
# 必须要要脚本所在目录运行该脚本以防出错

# 脚本当前目录
PWD_DIR=`pwd`
# 读取当前目录init.cnf文件参数
source ${PWD_DIR}/init.cnf

# 启动
cd ${PWD_DIR}
docker-compose up -d
