package com.xiong.mapper;

import com.xiong.entity.User;
import com.xiong.utils.ReturnInfo;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * @author DOCO
 * 2018/12/5 11:17
 */
public interface UserMapper {

    public List<User> findAll();

    public List<User> checkName(String name);

    public int changePassword(@Param("name")String name, @Param("password")String password, @Param("repassword")String repassword);

    public List<User> findByPage(@Param("start") Integer start, @Param("end") Integer end);

    public int addUser(User user);

    public int saveUser(User user);

    public int delUserById(Integer id);

    public List<User> findByNameAndPassword(@Param("name")String name, @Param("password")String password);
}
