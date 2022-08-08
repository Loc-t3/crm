package com.usercom.crm.commons.utils;

public class UUIDUtil {
    public static String getuuid(){
        return  UUIDUtil.uuid().toString().replaceAll("-","");
    }
}
