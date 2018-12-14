package com.xiong.controller;

import com.xiong.entity.User;
import com.xiong.service.impl.UserServiceImpl;
import com.xiong.utils.ReturnInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * @author DOCO
 * 2018/12/5 10:42
 */

@Controller
public class UserController {

    @Autowired
    private UserServiceImpl userServiceImpl;

    @RequestMapping("/list")
    public String list() {
        return "list";
    }

    @RequestMapping("/listPage")
    @ResponseBody
    public ReturnInfo listPage(@RequestParam(value = "page", required = false) Integer page,
                           @RequestParam(value = "limit", required = false) Integer limit, Model model) {
        ReturnInfo returnInfo = new ReturnInfo();
        List<User> list = userServiceImpl.findByPage(page, limit);
        returnInfo.setCode(0);
        returnInfo.setCount(userServiceImpl.findAll().size());
        returnInfo.setData(list);
        return returnInfo;
    }

    @RequestMapping(value = "/saveUser", method= RequestMethod.POST)
    @ResponseBody
    public int saveUser(Integer id, String name, Integer age, String address ,String desc) {
        User user = new User();
        user.setId(id);
        user.setUsername(name);
        user.setAge(age);
        user.setAddress(address);
        user.setDesc(desc);
        int res = userServiceImpl.saveUser(user);
        return  res;
    }
    @RequestMapping("/delUser")
    @ResponseBody
    public ReturnInfo saveUser(String ids) {
        ReturnInfo returnInfo = new ReturnInfo();
        System.out.println(ids);
        int count = 0;
        String[] arr = ids.split(",");
        for (int i = 0; i < arr.length; i++) {
            if(userServiceImpl.delUserById(Integer.parseInt(arr[i])) > 0)
                count++ ;
        }
        returnInfo.setCode(0);//表示成功
        returnInfo.setCount(count);
        System.out.println(count);
        return returnInfo;
    }
    @RequestMapping("/openAdd.do")
    public String openAdd() {
        return  "add";
    }

}
