<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.cracker.buka.Chapter" %>
<%@ page import="org.json.JSONArray" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Buka Cracker</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<nav class="navbar navbar-inverse" role="navigation">
  <div class="navbar-header">
  <a class="navbar-brand" href="/">Buka Cracker V3.2</a>
  </div>
  <ul class="nav navbar-nav">
    <li><a href="http://www.nobodycrackme.tk">Developer's Blog</a></li>
    </ul>
  <div class="navbar-form navbar-right" role="search">
  <div class="form-group">
    <input id="mid_input" type="text" class="form-control" placeholder="漫画名、作者">
  </div>
  <a id="query" class="btn btn-danger">搜索漫画</a>
</div>
</nav>

<div class="container" style="margin:0 auto;width:730px">
<h4><span class="label label-danger">强烈建议</span> 进入全屏方式浏览</h4><br>
<button type="button" class="btn btn-warning pull-left lastChap">上一册</button>
<button type="button" class="btn btn-warning pull-right nextChap">下一册</button><br>
<%
String midStr = request.getParameter("mid");
String cidStr = request.getParameter("cid");
boolean error = false;
if (midStr == null || cidStr == null) {
	error = true;
}
try {
	int midInt = Integer.parseInt(midStr);
	int cidInt = Integer.parseInt(cidStr);
} catch (Exception e) {
	error = true;
}
if (error) {
	%>锟斤拷，锟斤拷，锟斤拷，烫烫烫烫烫烫烫烫烫烫烫烫……<br>
	出bug了，我也不知道为啥<%
} else {
Cookie cookie = new Cookie(midStr, cidStr);
cookie.setMaxAge(60*60*24*365);
response.addCookie(cookie);
Chapter.getIndex(midStr, cidStr);

for (int i = 0; i < Chapter.pics.length(); i++) {
	String imgName = Chapter.pics.getString(i);
%>
<br>
<span class="label label-info">第<%=(i+1) %>页</span>
<img src="http://c-pic3.weikan.cn/pics/<%=midStr %>/<%=cidStr %>/<%=imgName %>" width="720px"
onError="this.src='http://c-r2.sosobook.cn/pics/<%=midStr %>/<%=cidStr %>/<%=imgName %>';"/>
<br>
<%
}
}
%>
<br>
<h4><span class="label label-danger">本册结束，看完漫画注意休息一下</span></h4>
<button type="button" class="btn btn-warning pull-left lastChap">上一册</button>
<button type="button" class="btn btn-warning pull-right nextChap">下一册</button><br>
<br>
</div>

<script src="https://code.jquery.com/jquery.js"></script>
<script src="js/bootstrap.min.js"></script>
<script>
$(document).ready(function(){
	$("#mid_input").keyup(function(e){
		if (e.keyCode == 13) {
			window.location.href='search.jsp?text=' + $("#mid_input").val();
		}
	});
    $("#query").click(function() {
	    window.location.href='search.jsp?text=' + $("#mid_input").val();
    });
    $(".nextChap").click(function() {
    	window.location.href='chapter.jsp?mid=<%=midStr %>&cid=<%=Chapter.getNextChapter(midStr, cidStr) %>';
    });
    $(".lastChap").click(function() {
    	window.location.href='chapter.jsp?mid=<%=midStr %>&cid=<%=Chapter.getLastChapter(midStr, cidStr) %>';
    });
});
</script>
</body>
</html>