<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.cracker.buka.Manga" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONObject" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Buka Cracker</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="css/bootstrap.min.css" rel="stylesheet">
<style type="text/css">
.shadow {
    background-color :rgba(255, 255, 255, 0.9);
    margin: 5px;
    padding: 20px;
    border-radius:5px;
    -moz-box-shadow: 0 0 10px rgba(0, 0, 0, 0.8);
    -webkit-box-shadow: 0 0 10px rgba(0, 0, 0, 0.8);
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.8);
    /* For IE 8 */
    -ms-filter: "progid:DXImageTransform.Microsoft.Shadow(Strength=2, Direction=135, Color='#000000')";
    /* For IE 5.5 - 7 */
    filter: progid:DXImageTransform.Microsoft.Shadow(Strength=2, Direction=135, Color='#000000');
}

body {
    padding-top:80px;
    background-image:url(img/background.gif);
    margin-left: 250px;
    margin-right: 300px;
}

</style>
</head>
<body>
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
<div class="container shadow" style="margin:0 auto;width:730px">
<%
String mid = request.getParameter("mid");
boolean error = false;
if (mid == null) {
	error = true;
}
try {
    int midInt = Integer.parseInt(mid);
} catch (Exception e) {
	error = true;
}
if (error) {
	%>锟斤拷，锟斤拷，锟斤拷，烫烫烫烫烫烫烫烫烫烫烫烫……<br>
	出bug了，我也不知道为啥<%
} else {
Cookie[] cookies = request.getCookies();
String lastCid = null;
for (int i = 0; i < cookies.length; i++) {
	Cookie c = cookies[i];
	if (c.getName().startsWith(mid)) {
		lastCid = c.getValue();
	}
}
Manga.getDetail(mid);
JSONObject manga = Manga.manga;
String name = manga.getString("name");
String intro = manga.getString("intro");
String logoUrl = manga.getString("logo");
String author = manga.getString("author");
String lastup = manga.getString("lastup");
String lastuptime = manga.getString("lastuptime");
%>
<div class="row">
<div class="col-md-4" style="text-align:center;vertical-align:middle">
<img src="<%=logoUrl %>" class="img-thumbnail" /><br>
<span class="label label-primary">MID: <%=mid %></span>
</div>
<div class="col-md-8">
<h2><%=name %></h2>
<h4><strong><%=author %></strong></h4>
介绍：<br>
<%=intro %><br><br>
<strong>
最新一话：<span class="label label-info"><%=lastup %></span> 上次更新时间：<span class="label label-info"><%=lastuptime %></span>
</strong>
</div>
</div>
<br><br>
漫画内容：<br>
<%
JSONArray links = manga.getJSONArray("links");
for (int i = 0; i < links.length(); i++) {
	JSONObject link = links.getJSONObject(i);
	String idx = link.getString("idx");
	String title = link.getString("title");
	String but = idx + " " + title;
	String cid = link.getString("cid");
	String buttonStyle = "btn-info";
	if (lastCid != null && cid.equals(lastCid)) {
		buttonStyle = "btn-danger current";
	}
%>
<button id="<%=cid %>" type="button" class="btn <%=buttonStyle %> chap-btn" style="margin:10px 3px"><%=but %></button>
<%
}
}
%>
</div>
<!-- Duoshuo Comment BEGIN -->
	<div class="ds-thread"></div>
<script type="text/javascript">
var duoshuoQuery = {short_name:"bukacracker"};
	(function() {
		var ds = document.createElement('script');
		ds.type = 'text/javascript';ds.async = true;
		ds.src = 'http://static.duoshuo.com/embed.js';
		ds.charset = 'UTF-8';
		(document.getElementsByTagName('head')[0] 
		|| document.getElementsByTagName('body')[0]).appendChild(ds);
	})();
	</script>
<!-- Duoshuo Comment END -->

<script src="https://code.jquery.com/jquery.js"></script>
<script src="js/bootstrap.min.js"></script>
<script>
$(document).ready(function(){
	$("#mid_input").keyup(function(e){
		if (e.keyCode == 13) {
			window.location.href='search.jsp?text=' + $("#mid_input").val();
		}
	});
$("#query").click(function(){
	window.location.href='search.jsp?text=' + $("#mid_input").val();
});

$(".chap-btn").click(function(){
	window.open("chapter.jsp?mid=<%=mid %>&cid=" + $(this).attr("id"));
	$(".current").remove("btn-danger");
	$(".current").addClass("btn-info");
	$(".current").remove("current");
	$(this).removeClass("btn-info");
	$(this).addClass("btn-danger");
	$(this).addClass("current");
});
});
</script>
</body>
</html>