<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.cracker.buka.Recommend" %>
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
    padding: 10px;
    border-radius: 20px 20px 5px 5px;
    -moz-box-shadow: 0 0 4px rgba(0, 0, 0, 0.5);
    -webkit-box-shadow: 0 0 4px rgba(0, 0, 0, 0.5);
    box-shadow: 0 0 4px rgba(0, 0, 0, 0.5);
    /* For IE 8 */
    -ms-filter: "progid:DXImageTransform.Microsoft.Shadow(Strength=2, Direction=135, Color='#000000')";
    /* For IE 5.5 - 7 */
    filter: progid:DXImageTransform.Microsoft.Shadow(Strength=2, Direction=135, Color='#000000');
}
img {
    margin: 3px;
}
body {
    padding-top:80px;
    background-image:url(img/background.gif);
}
#container {
    margin-left:60px;
}
</style>
</head>
<body>
<nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
  <div class="navbar-header">
  <a class="navbar-brand" href="#">Buka Cracker V3.2</a>
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
<div class="container" style="margin:0 auto">
<%
Recommend.getReco();
Recommend.getHot();
%>
<div id="container">
<%
for (int i = 0; i < Recommend.headArr.length() + Recommend.hotHeadArr.length(); i++) {
%><div class="item shadow" style="width:220px"><%
JSONObject head = null;
    if (i < Recommend.headArr.length()) {
        head = Recommend.headArr.getJSONObject(i);
    } else {
	    head = Recommend.hotHeadArr.getJSONObject(i - Recommend.headArr.length());
    }
	String title = head.getString("title");
	String text = head.getString("text");
	String headImageUrl = head.getString("logourl");
	String mid = head.getString("ctrlparam");
	String cid = head.getString("lastup");
%>
<span class="label label-primary">MID: <%=mid %></span><br>
<a href="manga.jsp?mid=<%=mid %>"><img src="<%=headImageUrl %>" width="100%"/></a><br>
<strong><a href="manga.jsp?mid=<%=mid %>"><%=title %></a></strong> <a href="chapter.jsp?mid=<%=mid %>&cid=<%=cid %>" class="btn btn-warning" role="button">最新一话</a><br>
</div><%
}
for (int i = 0; i < Recommend.itemsArr.length() + Recommend.hotItemsArr.length(); i++) {
%><div class="item shadow" style="width:220px"><%
    JSONObject item = null;
    if (i < Recommend.itemsArr.length()) {
	    item = Recommend.itemsArr.getJSONObject(i);
    } else {
    	item = Recommend.hotItemsArr.getJSONObject(i - Recommend.itemsArr.length());
    }
	String title = item.getString("title");
	String text = item.getString("text");
	String itemImageUrl = item.getString("logourl");
	String mid = item.getString("ctrlparam");
	String cid = item.getString("lastup");
%>
<span class="label label-primary">MID: <%=mid %></span><br>
<a href="manga.jsp?mid=<%=mid %>"><img src="<%=itemImageUrl %>" width="100%"/></a><br>
<strong><%=(i+1) %>.</strong>
<a href="manga.jsp?mid=<%=mid %>"><%=title %></a> <a href="chapter.jsp?mid=<%=mid %>&cid=<%=cid %>" class="btn btn-warning" role="button"><%=text %></a><br>
</div><%
}
%>
</div> 
</div>
<script src="js/jquery.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<script src="js/masonry.pkgd.min.js"></script>
<script src="js/imagesloaded.pkgd.min.js"></script>
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
	var $con = $('#container');
	$con.imagesLoaded(function(){
		$con.masonry({
			  columnWidth: 250,
			  itemSelector: '.item'
		});
	});
	$(".shadow").hover(function () {
		$(this).css('background-color', 'rgba(255, 255, 255, 1.0)');
		$(this).animate({
			width:'300px',
			left:'-=40px'});
		$(this).css('z-index', 1000);
		$(this).css('box-shadow', '0 0 80px rgba(0, 0, 0, 1)');
	}, function () {
		$(this).css('background-color', 'rgba(255, 255, 255, 0.9)');
		$(this).animate({
			width:'220px',
			left:'+=40px'});
		$(this).css('z-index', 1);
		$(this).css('box-shadow', '0 0 4px rgba(0, 0, 0, 0.5)');
	});
});
</script>
</body>
</html>