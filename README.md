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
now: 1712053158723546 timeout: 2000000
utilTimeToAct: -2000000
You can execute the business logic immediately.

---------

now: 1712053159053695 timeout: 2000000
utilTimeToAct: -1330149
You can execute the business logic immediately.

---------

now: 1712053159384911 timeout: 2000000
utilTimeToAct: -661365
You can execute the business logic immediately.

---------

now: 1712053159709588 timeout: 2000000
utilTimeToAct: 13958
You should wait 13958 microseconds before executing the business logic.

---------

now: 1712053160040008 timeout: 2000000
utilTimeToAct: 683538
You should wait 683538 microseconds before executing the business logic.

---------

now: 1712053160366991 timeout: 2000000
utilTimeToAct: 1356555
You should wait 1356555 microseconds before executing the business logic.

---------

now: 1712053160697141 timeout: 2000000
err: You cannot obtain permission to execute the business logic within 2000000 microseconds. Please give up on execution and return an error indicating the business system is busy.

---------

now: 1712053161025215 timeout: 2000000
utilTimeToAct: 1698331
You should wait 1698331 microseconds before executing the business logic.

---------

now: 1712053161357385 timeout: 2000000
err: You cannot obtain permission to execute the business logic within 2000000 microseconds. Please give up on execution and return an error indicating the business system is busy.

---------

now: 1712053161683467 timeout: 2000000
err: You cannot obtain permission to execute the business logic within 2000000 microseconds. Please give up on execution and return an error indicating the business system is busy.

---------

now: 1712053162011716 timeout: 2000000
utilTimeToAct: 1711830
You should wait 1711830 microseconds before executing the business logic.

---------

now: 1712053162338879 timeout: 2000000
err: You cannot obtain permission to execute the business logic within 2000000 microseconds. Please give up on execution and return an error indicating the business system is busy.

---------

now: 1712053162663490 timeout: 2000000
err: You cannot obtain permission to execute the business logic within 2000000 microseconds. Please give up on execution and return an error indicating the business system is busy.

---------

now: 1712053162986853 timeout: 2000000
utilTimeToAct: 1736693
You should wait 1736693 microseconds before executing the business logic.

---------

now: 1712053163309248 timeout: 2000000
err: You cannot obtain permission to execute the business logic within 2000000 microseconds. Please give up on execution and return an error indicating the business system is busy.

---------

now: 1712053163642396 timeout: 2000000
err: You cannot obtain permission to execute the business logic within 2000000 microseconds. Please give up on execution and return an error indicating the business system is busy.

---------

now: 1712053163972071 timeout: 2000000
utilTimeToAct: 1751475
You should wait 1751475 microseconds before executing the business logic.

---------

now: 1712053164303218 timeout: 2000000
err: You cannot obtain permission to execute the business logic within 2000000 microseconds. Please give up on execution and return an error indicating the business system is busy.

---------

now: 1712053164631533 timeout: 2000000
err: You cannot obtain permission to execute the business logic within 2000000 microseconds. Please give up on execution and return an error indicating the business system is busy.

---------

now: 1712053164954862 timeout: 2000000
utilTimeToAct: 1768684
You should wait 1768684 microseconds before executing the business logic.

---------

Completed 20 attempts.
```