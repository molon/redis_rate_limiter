#!/bin/bash

# 最大执行次数
maxAttempts=20

# 执行次数计数器
count=0

# 循环，直到达到最大执行次数
while [ $count -lt $maxAttempts ]
do
    # 执行 example.sh 脚本，传递 reserve 作为参数
    bash ./example.sh reserve
    
    # 计数器加 1
    ((count++))
    
    # 等待 300 毫秒
    sleep 0.3

    echo
    echo "---------"
    echo
done

echo "Completed $count attempts."
