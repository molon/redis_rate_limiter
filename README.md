# redis_rate_limiter

基于 redis 的限流方案
- **突发请求支持**：允许一定量的突发请求，甚至临时更改令牌桶容量。
- **调用方可控**：调用发可知需等待时长，可决定最大等待时长、甚至可取消令牌。

```bash
# redis-cli --eval reserve.lua <key> , <durationPerToken> <burst> <tokens> <now> <deadline>

# 频繁执行即可模拟预留令牌的操作
bash ./example.sh reserve

# 模拟取消预留
bash ./example.sh cancel
```

具体描述请详看 `./example.sh`
