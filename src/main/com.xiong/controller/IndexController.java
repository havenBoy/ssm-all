package com.xiong.controller;

import com.xiong.entity.User;
import com.xiong.service.impl.UserServiceImpl;
import com.xiong.utils.ReturnInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;

import java.util.List;

/**
 * @author DOCO
 * 2018/12/6 17:42
 */
@Controller
public class IndexController {

    private final static Logger logger = LoggerFactory.getLogger(IndexController.class);

    @Autowired
    private UserServiceImpl userServiceImpl;

    @Autowired
    private JedisPool jedisPool;

    @RequestMapping("/")
    public String index() {
        return "index";
    }

    @RequestMapping("/register")
    public String register() {
        return "register";
    }

    @RequestMapping("/rePassword")
    @ResponseBody
    public ReturnInfo setPassword(String name, String password, String repassword) {
        ReturnInfo ret = new ReturnInfo();
        int code = userServiceImpl.changePassword(name, password,repassword);
        ret.setCode(code);
        return ret;
    }

    @RequestMapping("/checkUser")
    @ResponseBody
    public ReturnInfo checkName(String name, String password) {
        ReturnInfo ret = new ReturnInfo();
        List<User> list = userServiceImpl.checkUser(name, password);
        ret.setCode(list.size());
        return ret;
    }

    @RequestMapping("/login")
    @ResponseBody
    public ReturnInfo login(String name, String password) {
        ReturnInfo ret = new ReturnInfo();
        Jedis jedis = jedisPool.getResource();
        String nameSys = jedis.get("name");
        String passwordSys = jedis.get("password");
        if(!StringUtils.isEmpty(nameSys) && !StringUtils.isEmpty(passwordSys) ) {
            if(nameSys.equals(name) && passwordSys.equals(password)) {
                ret.setCode(1);
            }
        } else {
            List<User> list = userServiceImpl.findByNameAndPassword(name,password);
            if(list.size() > 0) {
                ret.setCode(1);
            } else {
                ret.setCode(0);
            }
        }
        return ret;
    }

}
