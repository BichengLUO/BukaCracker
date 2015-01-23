package com.cracker.buka;

import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.zip.GZIPInputStream;

import org.json.JSONArray;
import org.json.JSONObject;

public class Recommend {
	public static JSONArray headArr;
	public static JSONArray itemsArr;
	
	public static JSONArray hotHeadArr;
	public static JSONArray hotItemsArr;

	public static void getReco() {
		JSONObject recoJSON = postAndReadJSON(Constraint.recPostData);
		headArr = recoJSON.getJSONArray("head");
		itemsArr = recoJSON.getJSONArray("items");
	}
	
	public static void getHot() {
		JSONObject hotJSON = postAndReadJSON(Constraint.hotPostData);
		hotHeadArr = hotJSON.getJSONArray("head");
		hotItemsArr = hotJSON.getJSONArray("items");
	}
	
	private static JSONObject postAndReadJSON(String postData) {
		JSONObject obj = null;
		try {
			URL url = new URL(Constraint.urlStr);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setDoOutput(true);
			conn.setDoInput(true);
			conn.setRequestMethod("POST");
			conn.setUseCaches(false);
			conn.setRequestProperty("Content-Type",
					"application/x-www-form-urlencoded");
			conn.connect();
			DataOutputStream out = new DataOutputStream(conn.getOutputStream());
			out.writeBytes(postData);
			out.flush();
			out.close();
			GZIPInputStream gis = new GZIPInputStream(conn.getInputStream());
			int count = 0;
			byte[] data = new byte[1024];
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			while ((count = gis.read(data, 0, 1024)) != -1) {
				baos.write(data, 0, count);
			}
			String jsonStr = baos.toString("utf-8");
			jsonStr = Constraint.imageUrlDecode(Constraint.decode(jsonStr));
			obj = new JSONObject(jsonStr);
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return obj;
	}
}
