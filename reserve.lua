local key = KEYS[1]
local durationPerToken = tonumber(ARGV[1]) -- 每个令牌所需的时间间隔，单位微秒
local burst = tonumber(ARGV[2]) -- 突发容量
local tokens = tonumber(ARGV[3]) -- 请求的令牌数量
local now = tonumber(ARGV[4]) -- 当前时间，单位微妙
local deadline = tonumber(ARGV[5]) -- 操作的截止时间，单位微秒

-- 计算基于当前时间和 burst 时长的重置值
local resetValue = now - (burst * durationPerToken)

-- 尝试获取 baseTime
local baseTime = tonumber(redis.call("get", key))

-- 如果 baseTime 不存在或小于计算出的重置值，则更新为重置值
if not baseTime or baseTime < resetValue then
    baseTime = resetValue
end

-- 计算 tokens 所占用的时间长度
local tokensDuration = tokens * durationPerToken
local timeToAct = baseTime + tokensDuration

-- 如果计算的 timeToAct 超过了 deadline，则不更新 baseTime，直接返回错误
if timeToAct > deadline then
    return -1 -- 返回一个错误标识，例如 -1
else
    -- 更新 baseTime 为下一个请求的执行时间
    redis.call("set", key, timeToAct)
    -- 返回下一个操作应该执行的时间点
    return timeToAct
end
