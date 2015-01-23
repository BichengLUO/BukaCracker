<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.cracker.buka.Search" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="java.net.URLEncoder" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Buka Cracker</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body style="padding-top:70px">
<nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
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
<%
String keyword = request.getParameter("text");
boolean error = false;
if (keyword == null) {
	error = true;
}
if (error) {
	%>锟斤拷，锟斤拷，锟斤拷，烫烫烫烫烫烫烫烫烫烫烫烫……<br>
	出bug了，我也不知道为啥<%
} else {
	String shownKw = new String(keyword.getBytes("iso-8859-1"), "utf-8");
%>
<span class="label label-danger">“<%=shownKw %>”</span>的搜索结果如下：<br><br>
<table class="table table-hover" style="width:700px">
<%
Search.search(keyword);
JSONArray resultArr = Search.resultArr;
for (int i = 0; i < resultArr.length(); i++) {
%><tr><%
    JSONObject item = resultArr.getJSONObject(i);
	String name = item.getString("name");
	String author = item.getString("author");
	String lastup = "最新一话";
	if (item.has("lastup")) {
	    lastup = item.getString("lastup");
	}
	String itemImageUrl = item.getString("logo");
	String mid = item.getString("mid");
	String cid = item.getString("lastchap");
%>
<td><img src="<%=itemImageUrl %>" class="img-rounded" width="80px"/></td>
<td><strong><%=(i+1) %>.</strong></td>
<td><a href="manga.jsp?mid=<%=mid %>"><%=name %></a><br></td>
<td><%=author %></td>
<td><span class="label label-primary">MID: <%=mid %></span></td>
<td><h4><a href="chapter.jsp?mid=<%=mid %>&cid=<%=cid %>" class="btn btn-warning" role="button"><%=lastup %></a></h4></td>
</tr><%
}
}
%>
</table> 
</div>
<script src="https://code.jquery.com/jquery.js"></script>
<script src="js/bootstrap.min.js"></script>
<script>
$("#mid_input").keyup(function(e){
	if (e.keyCode == 13) {
		window.location.href='search.jsp?text=' + $("#mid_input").val();
	}
});
$(document).ready(function(){
	$("#query").click(function() {
		window.location.href='search.jsp?text=' + $("#mid_input").val();
	});
});
</script>
</body>
</html>