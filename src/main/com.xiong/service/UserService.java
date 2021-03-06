package com.xiong.service;

import com.xiong.entity.User;
import com.xiong.utils.ReturnInfo;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author DOCO
 * 2018/12/5 15:11
 */
@Service
public interface UserService {

    public List<User> findAll();

    public List<User> checkUser(String name, String password);

    public int changePassword(String name, String password,String repassword);

    public List<User> findByPage(int page, int limit);

    public int addUser(User user);

    public int saveUser(User user);

    public int delUserById(Integer id);

    public List<User> findByNameAndPassword(String name, String password);
}
