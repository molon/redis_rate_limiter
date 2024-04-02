#!/bin/bash

# 检查参数
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <action>"
    echo "action: reserve or cancel"
    exit 1
fi
action=$1

key="rlimiter:testKey" # 令牌桶名称
durationPerToken=1000000 # 令牌生成间隔（微秒），此例为1秒
burst=3 # 令牌桶最大容量
tokens=1 # 请求预留的令牌数量
# 预期最大等待时间（微秒），此例为2秒
# 这个值意味想要预留 tokens 所需的时长不得超过 timeout，否则直接放弃预留，令牌桶不受影响
# 若调用方不希望等待，此值设置为0即可
timeout=2000000 

# 如果是 macOS, 需要安装 coreutils 来使用 `gdate` 获取微秒级时间戳
if ! command -v gdate &> /dev/null; then
    echo "Attempting to install coreutils for gdate command..."
    brew install coreutils &> /dev/null
    if [ $? -eq 0 ]; then
        echo "Coreutils installed successfully."
    else
        echo "Installation failed. Please verify your Homebrew setup."
        exit 1
    fi
fi

if [ "$action" == "reserve" ]; then
    now=$(gdate +%s%6N) # 获取当前时间的微秒级时间戳
    echo 'now:' $now "timeout:" $timeout
    deadline=$((now + timeout)) # 计算预期最大截止时间

    # 调用 redis 执行 reserve.lua 脚本，获取行动触发时间点
    timeToAct=$(redis-cli --eval reserve.lua $key , $durationPerToken $burst $tokens $now $deadline)
    # echo "timeToAct: $timeToAct"

    if [[ $timeToAct -lt 0 ]]; then
        # 超过预设的最大等待时间，放弃预留并返回错误
       echo "err: You cannot obtain permission to execute the business logic within $timeout microseconds. "
       echo "Please give up on execution and return an error indicating the business system is busy."
    else
        # 如果 timeToAct 大于当前时间，应计算并等待需要的延迟；否则无需等待
        utilTimeToAct=$((timeToAct - now))
        echo "utilTimeToAct: $utilTimeToAct" 
        if [[ $utilTimeToAct -gt 0 ]]; then
            echo "You should wait $utilTimeToAct microseconds before executing the business logic."
        else
            echo "You can execute the business logic immediately."
        fi
    fi
elif [ "$action" == "cancel" ]; then
    # 取消逻辑：使用 DECRBY 减少 baseTime
    # 但请注意，通常是 reserve 操作获取到的 timeToAct 还未触达之前才有权按需取消，需调用方自行判断
    decrement=$((tokens * durationPerToken))
    echo "Cancelling $tokens tokens, decrementing by $decrement microseconds"
    newBaseTime=$(redis-cli DECRBY $key $decrement)
    echo "New base time: $newBaseTime"
else
    echo "Invalid action: $action"
    echo "Valid actions are 'reserve' or 'cancel'."
    exit 1
fi
