package com.usercom.crm.commons.utils;

import java.text.SimpleDateFormat;
import java.util.Date;

public class DateUtils {
    public  static  String formdateTime(Date date){
         SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        final String format1 = format.format(date);
        return format1;

    }
}
