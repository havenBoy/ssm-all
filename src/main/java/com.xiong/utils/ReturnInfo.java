package com.xiong.utils;

import java.util.List;

/**
 * \* Created with IntelliJ IDEA.
 * \* User: Administrator
 * \* Date: 2018/12/5
 * \* Time: 22:22
 * \* To change this template use File | Settings | File Templates.
 * \* Description:
 * \
 */
public class ReturnInfo {

    private int code;

    private String msg;

    private int count;

    private List<?> data;

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public int getCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
    }

    public List<?> getData() {
        return data;
    }

    public void setData(List<?> data) {
        this.data = data;
    }
}
