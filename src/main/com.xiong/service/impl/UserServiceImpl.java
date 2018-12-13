package com.xiong.service.impl;

import com.xiong.entity.User;
import com.xiong.mapper.UserMapper;
import com.xiong.utils.ReturnInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * @author DOCO
 * 2018/12/5 15:11
 */

@Service
@Transactional
public class UserServiceImpl implements UserMapper{

    @Autowired
    private UserMapper userMapper;

    @Override
    public List<User> findAll() {
        return userMapper.findAll();
    }

    @Override
    public List<User> checkName(String name) {
        return userMapper.checkName(name);
    }

    @Override
    public int changePassword(String name, String pasword, String repassword) {
        return  userMapper.changePassword(name, pasword,repassword);
    }

    @Override
    public List<User> findByPage(Integer page, Integer limit) {
        int start = (page-1) * limit ;
        int end = page * limit;
        return userMapper.findByPage(start, end);
    }

    @Override
    public int addUser(User user) {
        int result = userMapper.addUser(user);
        return result;
    }

    @Override
    public int saveUser(User user) {
        int res = userMapper.saveUser(user);
        return res;
    }

    @Override
    public int delUserById(Integer id) {
        return userMapper.delUserById(id);
    }

    @Override
    public List<User> findByNameAndPassword(String name, String password) {
        return userMapper.findByNameAndPassword(name, password);
    }
}
