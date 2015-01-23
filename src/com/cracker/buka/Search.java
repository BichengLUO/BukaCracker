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

public class Search {
	public static JSONArray resultArr;
	
	public static void search(String text) {
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
			out.writeBytes(Constraint.srchPostData(text));
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
			JSONObject resultObj = new JSONObject(jsonStr);
			resultArr = resultObj.getJSONArray("items");
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
