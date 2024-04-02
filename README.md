# redis_rate_limiter

基于 redis 的限流方案
- **突发请求支持**：允许一定量的突发请求，甚至临时更改令牌桶容量。
- **调用方可控**：调用发可知需等待时长，可决定最大等待时长、甚至可取消令牌。

```bash
# reserve.lua 用法
# redis-cli --eval reserve.lua <key> , <durationPerToken> <burst> <tokens> <now> <deadline>

# 运行 redis-server
redis-server

# 频繁执行即可模拟预留令牌的操作
bash ./run_example.sh

# 模拟取消预留
bash ./example.sh cancel
```

具体描述请详看 `./example.sh`   

# 案例
`bash ./run_example.sh` 执行日志:
```
now: 1712053339218374 timeout: 2000000
utilTimeToAct: -2000000
You can execute the business logic immediately.

---------

now: 1712053339553444 timeout: 2000000
utilTimeToAct: -1335070
You can execute the business logic immediately.

---------

now: 1712053339882651 timeout: 2000000
utilTimeToAct: -664277
You can execute the business logic immediately.

---------

now: 1712053340213767 timeout: 2000000
utilTimeToAct: 4607
You should wait 4607 microseconds before executing the business logic.

---------

now: 1712053340544279 timeout: 2000000
utilTimeToAct: 674095
You should wait 674095 microseconds before executing the business logic.

---------

now: 1712053340877906 timeout: 2000000
utilTimeToAct: 1340468
You should wait 1340468 microseconds before executing the business logic.

---------

now: 1712053341212147 timeout: 2000000
err: You cannot obtain permission to execute the business logic within 2000000 microseconds. 
Please give up on execution and return an error indicating the business system is busy.

---------

now: 1712053341547496 timeout: 2000000
utilTimeToAct: 1670878
You should wait 1670878 microseconds before executing the business logic.

---------

now: 1712053341877344 timeout: 2000000
err: You cannot obtain permission to execute the business logic within 2000000 microseconds. 
Please give up on execution and return an error indicating the business system is busy.

---------

now: 1712053342200889 timeout: 2000000
err: You cannot obtain permission to execute the business logic within 2000000 microseconds. 
Please give up on execution and return an error indicating the business system is busy.

---------

now: 1712053342533185 timeout: 2000000
utilTimeToAct: 1685189
You should wait 1685189 microseconds before executing the business logic.

---------

now: 1712053342868121 timeout: 2000000
err: You cannot obtain permission to execute the business logic within 2000000 microseconds. 
Please give up on execution and return an error indicating the business system is busy.

---------

now: 1712053343203083 timeout: 2000000
err: You cannot obtain permission to execute the business logic within 2000000 microseconds. 
Please give up on execution and return an error indicating the business system is busy.

---------

now: 1712053343538132 timeout: 2000000
utilTimeToAct: 1680242
You should wait 1680242 microseconds before executing the business logic.

---------

now: 1712053343874109 timeout: 2000000
err: You cannot obtain permission to execute the business logic within 2000000 microseconds. 
Please give up on execution and return an error indicating the business system is busy.

---------

now: 1712053344210357 timeout: 2000000
err: You cannot obtain permission to execute the business logic within 2000000 microseconds. 
Please give up on execution and return an error indicating the business system is busy.

---------

now: 1712053344547737 timeout: 2000000
utilTimeToAct: 1670637
You should wait 1670637 microseconds before executing the business logic.

---------

now: 1712053344881971 timeout: 2000000
err: You cannot obtain permission to execute the business logic within 2000000 microseconds. 
Please give up on execution and return an error indicating the business system is busy.

---------

now: 1712053345210946 timeout: 2000000
err: You cannot obtain permission to execute the business logic within 2000000 microseconds. 
Please give up on execution and return an error indicating the business system is busy.

---------

now: 1712053345542334 timeout: 2000000
utilTimeToAct: 1676040
You should wait 1676040 microseconds before executing the business logic.

---------

Completed 20 attempts.
```