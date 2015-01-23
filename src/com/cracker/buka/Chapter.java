package com.cracker.buka;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

import org.json.JSONArray;
import org.json.JSONObject;

public class Chapter {
	public static JSONArray pics;
	public static String jsonStr;

	public static void getIndex(String midStr, String cidStr) {
		try {
			String urlStr = Constraint.indexUrlStr + "?"
					+ Constraint.chapGetData(midStr, cidStr);
			URL url = new URL(urlStr);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.connect();
			InputStream is = conn.getInputStream();
			int count = 0;
			byte[] data = new byte[1024];
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			while ((count = is.read(data, 0, 1024)) != -1) {
				baos.write(data, 0, count);
			}
			byte[] bukaBytes = baos.toByteArray();
			byte[] lengthBytes = new byte[8];
			for (int i = 4; i < 12; i++) {
				lengthBytes[i - 4] = bukaBytes[i];
			}
			String lengthStr = new String(lengthBytes);
			int length = Integer.parseInt(lengthStr, 16);
			byte[] indexData = new byte[length];
			byte[] key = secretKey(Integer.parseInt(midStr),
					Integer.parseInt(cidStr));
			for (int i = 16; i < length + 12; i++) {
				indexData[i - 16] = (byte) (bukaBytes[i] ^ key[(i - 16) % 8]);
			}
			ByteArrayInputStream bais = new ByteArrayInputStream(indexData);
			ZipInputStream zip = new ZipInputStream(bais);
			ZipEntry ze;
			StringBuilder sb = new StringBuilder();
			while ((ze = zip.getNextEntry()) != null) {
				if (ze.getName().equals("index.dat")) {
					byte[] buffer = new byte[1024];
					int readCount = 0;
					while ((readCount = zip.read(buffer, 0, 1024)) >= 0) {
						sb.append(new String(buffer, 0, readCount, "utf-8"));
					}
				}
			}
			jsonStr = sb.toString();
			JSONObject index = new JSONObject(jsonStr);
			pics = index.getJSONArray("pics");
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	public static String getNextChapter(String midStr, String cidStr)
	{
		Manga.getDetail(midStr);
		JSONObject manga = Manga.manga;
		JSONArray links = manga.getJSONArray("links");
		int i;
		for (i = 0; i < links.length(); i++) {
			JSONObject link = links.getJSONObject(i);
			String cid = link.getString("cid");
			if (cid.equals(cidStr)) {
				break;
			}
		}
		if (i - 1 >= links.length() || i - 1 < 0) {
			return cidStr;
		} else {
			return links.getJSONObject(i-1).getString("cid");
		}
	}
	public static String getLastChapter(String midStr, String cidStr)
	{
		Manga.getDetail(midStr);
		JSONObject manga = Manga.manga;
		JSONArray links = manga.getJSONArray("links");
		int i;
		for (i = 0; i < links.length(); i++) {
			JSONObject link = links.getJSONObject(i);
			String cid = link.getString("cid");
			if (cid.equals(cidStr)) {
				break;
			}
		}
		if (i + 1 >= links.length()) {
			return cidStr;
		} else {
			return links.getJSONObject(i+1).getString("cid");
		}
	}

	private static byte[] secretKey(int i, int j) {
		byte[] abyte0 = new byte[8];
		abyte0[0] = (byte) j;
		abyte0[1] = (byte) (j >> 8);
		abyte0[2] = (byte) (j >> 16);
		abyte0[3] = (byte) (j >> 24);
		abyte0[4] = (byte) i;
		abyte0[5] = (byte) (i >> 8);
		abyte0[6] = (byte) (i >> 16);
		abyte0[7] = (byte) (i >> 24);
		return abyte0;
	}
}
