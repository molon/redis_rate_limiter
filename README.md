# redis_rate_limiter

基于 redis 的限流方案
- **突发请求支持**：允许一定量的突发请求，甚至临时微调令牌桶容量和生成速率。
- **调用方可控**：调用方可知需等待时长，可决定最大等待时长、甚至可取消已持有令牌。

```bash
# reserve.lua 用法
# redis-cli --eval reserve.lua <key> , <durationPerToken> <burst> <tokens> <now> <timeout>

# 运行 redis-server
redis-server

# 内部会频繁执行 example.sh reserve 以模拟预留令牌的操作
bash ./run_example.sh

# 模拟取消预留
bash ./example.sh cancel
```

具体描述请详看 `./example.sh` 和 `./reserve.lua`，代码量很少。

# 案例
`bash ./run_example.sh` 执行日志:

```
now: 1712054439699466 timeout: 2200000
utilTimeToAct: -2000000
You can execute the business logic immediately.
# 此种情况表示已获取并持有了令牌，并可立即执行。

---------

now: 1712054440032701 timeout: 2200000
utilTimeToAct: -1333235
You can execute the business logic immediately.

---------

now: 1712054440365200 timeout: 2200000
utilTimeToAct: -665734
You can execute the business logic immediately.

---------

now: 1712054440693657 timeout: 2200000
utilTimeToAct: 5809
You should wait 5809 microseconds before executing the business logic.
# 此种情况表示已获取并持有了令牌，但是需要等待一会再执行。
# 如果不希望有这个机制，调用方在调用时将 timeout 设置为 0 即可，则不会在此时持有令牌。

---------

now: 1712054441029928 timeout: 2200000
utilTimeToAct: 669538
You should wait 669538 microseconds before executing the business logic.

---------

now: 1712054441354570 timeout: 2200000
utilTimeToAct: 1344896
You should wait 1344896 microseconds before executing the business logic.

---------

now: 1712054441684566 timeout: 2200000
utilTimeToAct: 2014900
You should wait 2014900 microseconds before executing the business logic.

---------

now: 1712054442020443 timeout: 2200000
err: You cannot obtain permission to execute the business logic within 2200000 microseconds. 
Please give up on execution and return an error indicating the business system is busy.
# 此种情况表示，当前令牌桶繁忙，即使等待 timeout 也无法获取令牌。
# 此处可以看出如果 timeout 给到 0 ，也就相当于一般令牌桶的 Allow 方法。

---------

now: 1712054442359911 timeout: 2200000
err: You cannot obtain permission to execute the business logic within 2200000 microseconds. 
Please give up on execution and return an error indicating the business system is busy.

---------

now: 1712054442689560 timeout: 2200000
utilTimeToAct: 2009906
You should wait 2009906 microseconds before executing the business logic.

---------

now: 1712054443020018 timeout: 2200000
err: You cannot obtain permission to execute the business logic within 2200000 microseconds. 
Please give up on execution and return an error indicating the business system is busy.

---------

now: 1712054443351912 timeout: 2200000
err: You cannot obtain permission to execute the business logic within 2200000 microseconds. 
Please give up on execution and return an error indicating the business system is busy.

---------

now: 1712054443690266 timeout: 2200000
utilTimeToAct: 2009200
You should wait 2009200 microseconds before executing the business logic.

---------

now: 1712054444027671 timeout: 2200000
err: You cannot obtain permission to execute the business logic within 2200000 microseconds. 
Please give up on execution and return an error indicating the business system is busy.

---------

now: 1712054444364667 timeout: 2200000
err: You cannot obtain permission to execute the business logic within 2200000 microseconds. 
Please give up on execution and return an error indicating the business system is busy.

---------

now: 1712054444692661 timeout: 2200000
utilTimeToAct: 2006805
You should wait 2006805 microseconds before executing the business logic.

---------

now: 1712054445023608 timeout: 2200000
err: You cannot obtain permission to execute the business logic within 2200000 microseconds. 
Please give up on execution and return an error indicating the business system is busy.

---------

now: 1712054445357738 timeout: 2200000
err: You cannot obtain permission to execute the business logic within 2200000 microseconds. 
Please give up on execution and return an error indicating the business system is busy.

---------

now: 1712054445691356 timeout: 2200000
utilTimeToAct: 2008110
You should wait 2008110 microseconds before executing the business logic.

---------

now: 1712054446031482 timeout: 2200000
err: You cannot obtain permission to execute the business logic within 2200000 microseconds. 
Please give up on execution and return an error indicating the business system is busy.

---------

Completed 20 attempts.
```