package com.zhongju.buyu.sdk;

import java.util.HashMap;
import java.util.Map;

public class SDKUtil {
	public static Map<String,String> StringToMap(String info)
	{
		Map<String,String> map = new HashMap<String,String>();
		String[] arr = info.split("&");
		if(arr != null)
		{
			for(int i = 0;i < arr.length;i++)
			{
				String[] values = arr[i].split("=");
				map.put(values[0], values[1]);
			}
		}
		return map;
	}
}
