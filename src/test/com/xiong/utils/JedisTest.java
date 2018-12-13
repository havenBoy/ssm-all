package com.xiong.utils;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.BeanFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;

/**
 * @author DOCO
 * 2018/12/7 17:40
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("classpath:applicationContext.xml")
public class JedisTest {

    @Autowired
    private JedisPool jedisPool;

    private Jedis jedis;

    /*  @Before
    public void init() {
        ApplicationContext ctx = new ClassPathXmlApplicationContext("applicationContext.xml");
        jedisPool = (JedisPool)ctx.getBean("jedisPool");
        assert(jedisPool != null);
    }*/

    @Test
    public void testSpring() {
        ApplicationContext applicationContext =  new ClassPathXmlApplicationContext("applicationContext.xml");
        JedisPool jedisPool = (JedisPool)applicationContext.getBean("jedisPool");
        jedis = jedisPool.getResource();
        jedis.set("name","xiong");
        System.out.println(jedis.get("name"));
    }

    @Test
    public void redisCli() {
        jedisPool = new JedisPool(new JedisPoolConfig(),"172.16.20.39");
        jedis = jedisPool.getResource();
        jedis.set("name","xiong");
        System.out.println(jedis.get("name"));
    }
}
