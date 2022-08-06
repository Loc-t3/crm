package com.usercom.crm.commons.domain;

public class ReturnObject {
    private String code;//处理成功或者失败的标记信息 0 失败 1-- 成功
    private String message;//提示信息
    private String redata;//其它数据

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getRedata() {
        return redata;
    }

    public void setRedata(String redata) {
        this.redata = redata;
    }
}
