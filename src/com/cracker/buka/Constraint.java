package com.cracker.buka;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class Constraint {
	public static final String urlStr = "http://cs.sosohaha.com/request.php";
	public static final String indexUrlStr = "http://index.bukamanhua.com:8000/req2.php";
	public static final String recPostData = "i=%257B%2522count%2522%253A50%252C%2522f%2522%253A%2522func_recomhome3%2522%252C%2522start%2522%253A0%252C%2522pid%2522%253A1%257D&c=1B4E2F6587B49B5CAF70F50FF71BB4AA&z=1&p=android&v=4&cv=17170469&chn=home&myuid=1569338";
	public static final String hotPostData = "i=%257B%2522count%2522%253A50%252C%2522f%2522%253A%2522func_recomhome3%2522%252C%2522start%2522%253A0%252C%2522pid%2522%253A2%257D&c=6C0FEAB38EBE147CE11D0C0B0176AC40&z=1&p=android&v=4&cv=17170469&chn=home&myuid=1569338";
	public static final String manPostDataTemp = "i=%257B%2522f%2522%253A%2522func_getdetail%2522%252C%2522from%2522%253A%2522%2522%252C%2522mid%2522%253A{mid}%257D&c={c}&z=1&p=android&v=4&cv=17170469&chn=home&myuid=1569338";
	public static final String iTemp = "%7B%22f%22%3A%22func_getdetail%22%2C%22from%22%3A%22%22%2C%22mid%22%3A{mid}%7D";
	public static final String chapGetDataTemp = "mid={mid}&cid={cid}&c={c}&s=ao&v=2&t=-1";
	public static final String iSrchTemp = "%7B%22f%22%3A%22func_search%22%2C%22initc%22%3A%22%22%2C%22text%22%3A%22{text}%22%2C%22cate%22%3A0%2C%22count%22%3A20%2C%22order%22%3A0%2C%22start%22%3A0%2C%22recom%22%3A1%7D";
	public static final String srchPostDataTemp = "i=%257B%2522f%2522%253A%2522func_search%2522%252C%2522initc%2522%253A%2522%2522%252C%2522text%2522%253A%2522{text}%2522%252C%2522cate%2522%253A0%252C%2522count%2522%253A20%252C%2522order%2522%253A0%252C%2522start%2522%253A0%252C%2522recom%2522%253A1%257D&c={c}&z=1&p=android&v=4&cv=17170469&chn=home&myuid=1569338";

	public static String srchPostData(String text) {
		String i = iSrchTemp.replaceAll("\\{text\\}", text);
		String c = md5(i + "password error!");
		String srchPostData = srchPostDataTemp.replaceAll("\\{text\\}", text)
				.replaceAll("\\{c\\}", c);
		return srchPostData;
	}

	public static String chapGetData(String midStr, String cidStr) {
		String ct = String.format("%s,%s,%s", midStr, cidStr,
				"buka index error");
		String c = md5(ct).toLowerCase();
		String chapGetData = chapGetDataTemp.replaceAll("\\{mid\\}", midStr)
				.replaceAll("\\{cid\\}", cidStr).replaceAll("\\{c\\}", c);
		return chapGetData;
	}

	public static String imageUrlDecode(String str) {
		String result = str.replace("\\/", "/");
		return result;
	}

	public static String manPostDataWithMid(String midStr) {
		String i = iTemp.replaceAll("\\{mid\\}", midStr);
		String c = md5(i + "password error!");
		String manPostData = manPostDataTemp.replaceAll("\\{mid\\}", midStr)
				.replace("\\{c\\}", c);
		return manPostData;
	}

	public static String md5(String paramString) {
		try {
			MessageDigest localMessageDigest = MessageDigest.getInstance("MD5");
			localMessageDigest.update(paramString.getBytes());
			String str = encode(localMessageDigest.digest());
			return str;
		} catch (NoSuchAlgorithmException localNoSuchAlgorithmException) {
		}
		return "";
	}

	private static String encode(byte[] paramArrayOfByte) {
		char[] arrayOfChar = { 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66,
				67, 68, 69, 70 };
		StringBuilder localStringBuilder = new StringBuilder(
				2 * paramArrayOfByte.length);
		for (int i = 0; i < paramArrayOfByte.length; i++) {
			localStringBuilder
					.append(arrayOfChar[((0xF0 & paramArrayOfByte[i]) >>> 4)]);
			localStringBuilder.append(arrayOfChar[(0xF & paramArrayOfByte[i])]);
		}
		return localStringBuilder.toString();
	}

	public static String decode(String unicodeStr) {
		if (unicodeStr == null) {
			return null;
		}
		StringBuffer retBuf = new StringBuffer();
		int maxLoop = unicodeStr.length();
		for (int i = 0; i < maxLoop; i++) {
			if (unicodeStr.charAt(i) == '\\') {
				if ((i < maxLoop - 5)
						&& ((unicodeStr.charAt(i + 1) == 'u') || (unicodeStr
								.charAt(i + 1) == 'U')))
					try {
						retBuf.append((char) Integer.parseInt(
								unicodeStr.substring(i + 2, i + 6), 16));
						i += 5;
					} catch (NumberFormatException localNumberFormatException) {
						retBuf.append(unicodeStr.charAt(i));
					}
				else
					retBuf.append(unicodeStr.charAt(i));
			} else {
				retBuf.append(unicodeStr.charAt(i));
			}
		}
		return retBuf.toString();
	}
}
