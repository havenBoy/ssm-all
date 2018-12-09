package com.xiong.utils;

import org.junit.Before;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;

/**
 * @author DOCO
 * 2018/12/7 17:40
 */
public class JedisTest {

    @Autowired
    private JedisPool jedisPool;

    private Jedis jedis;

    @Test
    public void jedisTest() {
        jedis = jedisPool.getResource();
        jedis.set("name","xiong");
        System.out.println(jedis.get("name"));
    }

    @Test
    public void redisCli() {
        jedisPool = new JedisPool(new JedisPoolConfig(),"192.168.182.130");
        jedis = jedisPool.getResource();
        jedis.set("name","xiong");
        System.out.println(jedis.get("name"));
    }
}
