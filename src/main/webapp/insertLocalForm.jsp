<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>    
<%
	if(session.getAttribute("loginMemberId")== null){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css?family=Poppins:300,400,500,600,700" rel="stylesheet">
<link href="https://fonts.googleapis.com/css?family=Montserrat:300,400,500,700" rel="stylesheet">
<link rel="stylesheet" href="css/style.css">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<title>Insert title here</title>
</head>
<body>
	<div id="colorlib-page">
		<aside id="colorlib-aside" role="complementary" class="js-fullheight text-center">
			<h1 id="colorlib-logo"><a href="index.html">userboard project<span>.</span></a></h1>
			<div>
				<%
					//request.getRequestDispatcher(request.getContextPath()+"/inc/copyright.jsp").include(request, response); // request dispatcher 는 합치는 기능을 가지고 있다. 
					//include 는 a와 b 둘다 보이도록 합치고 forward는 a가 안보이도록 b를 합친다
					// 위에 코드를 액션태그로 변경하면 아래와 같다!
				%>
				<!--<jsp:include page ="/inc/copyright.jsp"></jsp:include>  include는 자바 서버에서 실행되는 부분 request가 필요없다-->
				   
				<!--jsp:include 태그는 다른 JSP 페이지나 HTML 파일 등을 포함시키는 데 사용되는데, 이 태그를 사용하면 지정된 파일의 내용이 현재 JSP 페이지에 포함됨-->
				<!--다만, 외부라이브러리 처럼 사용할 수 있는 action을 사용하면 안써도 된다.-->	
							
				<jsp:include page ="/inc/mainmenu.jsp"></jsp:include>  <!-- 메인메뉴 가로 -->		
			</div>	
		</aside>
		<div id="colorlib-main">
			<div class="hero-wrap js-fullheight" style="background-image: url(images/bg_1.jpg);" data-stellar-background-ratio="0.5">
				<div class="overlay"></div>
				<div class="js-fullheight d-flex justify-content-center align-items-center">
					<div class="col-md-8 text text-center">
						<div class="desc">
							<h2 class="subheading">userboard Project</h2>
							<h1 class="mb-4">프로젝트설명(~5.11)</h1>
							<p class="mb-4">I am A Blogger Far far away, behind the word mountains, far from the countries Vokalia and Consonantia, there live the blind texts. Separated they live in Bookmarksgrove right at the coast of the Semantics, a large language ocean.</p>
						</div>
					</div>
				</div>
			</div>
			<div>
				<h1>새지역 등록</h1>
				<br>
				<div>
					<!--insertLocal form-->
						<form action="<%=request.getContextPath()%>/local/insertLocalAction.jsp" method="post">	
								
							<table class="table table-hover">
								<tr class="table-info">
									<th colspan="2">지역이름</th>
									<th>등록</th>
								</tr>					
								<tr>
									<td><input type="text" name="localName"></td>
									<td>
										<%
											if(request.getParameter("msg")!=null){
										%>
												<font color="red"><%=request.getParameter("msg")%></font>
										<% 		
											}
										%>
									</td>
									<td><button type="submit">등록하기</button></td>
								</tr>	
							</table>
						</form>	
				</div>
			</div>		
		<footer class="ftco-footer ftco-bg-dark ftco-section">
      	<div>
			<!-- include 페이지 : Copyright &copy; 구디아카데미 -->
			<jsp:include page="/inc/copyright.jsp"></jsp:include>
		</div>
			  Copyright &copy;<script>document.write(new Date().getFullYear());</script> All rights reserved | This template is made with <i class="icon-heart" aria-hidden="true"></i> by <a href="https://colorlib.com" target="_blank">Colorlib</a>			     
   		</footer>
	
		</div><!-- END COLORLIB-MAIN -->
	</div><!-- END COLORLIB-PAGE -->	
</body>
</html>