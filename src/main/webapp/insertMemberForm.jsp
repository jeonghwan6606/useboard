<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>    
<%
	//세션 유효성 검사
	if(session.getAttribute("loginMemberId") != null){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}	

	String localName = "전체"; //"SELECT '전체' localName 위에서 설정한 colum 명 활용
	if(request.getParameter("localName")!=null){
		localName = request.getParameter("localName");
	}
		
	//2. 모델계층
	String driver="org.mariadb.jdbc.Driver";
	String dburl="jdbc:mariadb://3.38.38.146/userboard";
	String dbuser="root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	
	//2-1) 서브메뉴 결과셋(모델) 
	PreparedStatement subMenuStmt = null ;
	ResultSet subMenuRs = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	/*
	SELECT '전체' localName , COUNT(local_name) cnt FROM board
	UNION ALL
	SELECT local_name, COUNT(local_name) FROM board GROUP BY local_name;
	*/
	String subMenuSql = "SELECT '전체' localName , COUNT(local_name) cnt FROM board UNION ALL SELECT local_name, COUNT(local_name) FROM board GROUP BY local_name";
	subMenuStmt = conn.prepareStatement(subMenuSql);
	
	System.out.println(subMenuStmt+"<--loginListByMap stmt");
	subMenuRs =subMenuStmt.executeQuery();
	//HashMap은 Key-Value 쌍의 데이터를 저장하고 검색하는 데 사용, 
	//VO는 데이터를 캡슐화하고 해당 데이터에 접근하는 데 사용됨. 일반적으로 HashMap은 데이터를 저장하는 용도로 사용되고, VO는 데이터를 담는 객체로 사용됩니다 (vo는 불변성 특징을 가짐)
	
	//vo대신 HashMap 타입을 사용
	//subMenuList <--모델데이터 
	ArrayList<HashMap<String, Object>> subMenuList = new ArrayList<HashMap<String, Object>>();
	while(subMenuRs.next()){	
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("localName",subMenuRs.getString("localName"));
		m.put("cnt",subMenuRs.getInt("cnt"));
		subMenuList.add(m);
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
			<!-- 서브메뉴 세로 //subMenuList <--모델데이터를 출력 -->
			<div>	
				<!--home 내용: 로그인 form -->
				<!-- 로그인 form-->
				<%
					if(session.getAttribute("loginMemberId")==null){
				%>
					<!-- 현재 웹 애플리케이션의 컨텍스트 경로(Context Path)를 문자열로 반환-->
					<!-- 웹 애플리케이션의 경로가 변경되어도 자동으로 업데이트되므로 유지보수에 용이-->
					<form action = "<%=request.getContextPath()%>/member/loginAction.jsp" method="post"> 
					
						<table>
							<tr>
								<td>아이디</td>
								<td><input type="text" name="memberId"></td>
							</tr>
							<tr>
								<td>비밀번호</td>
								<td><input type="password" name="memberPw"></td>
							</tr>
						</table>
						<button type = "submit">로그인</button>
					</form>	
						
				<% 	
					}
				%>
			</div>
			<div>
				<%
					for(HashMap<String, Object> m : subMenuList) {
				%>
						<li class="colorlib-active">
								<a href="<%=request.getContextPath()%>/home.jsp?localName=<%=(String)m.get("localName")%>">
									<%=(String)m.get("localName")%>(<%=(Integer)m.get("cnt")%>) <!-- (Sting) 형변환, (Integer) 정수 형변환 -->
								</a>
						</li>
				<%		
					}
				%>
			</div>
		</aside>
		<div id="colorlib-main">
			<div class="hero-wrap js-fullheight" style="background-image: url(images/bg_1.jpg);" data-stellar-background-ratio="0.5">
				<div class="overlay"></div>
				<div class="js-fullheight d-flex justify-content-center align-items-center">
					<div class="col-md-8 text text-center">
						<div class="desc">
							<h2 class="subheading">userboard Project</h2>
							<h1 class="mb-4">프로젝트설명(~5.9)</h1>
							<p class="mb-4">I am A Blogger Far far away, behind the word mountains, far from the countries Vokalia and Consonantia, there live the blind texts. Separated they live in Bookmarksgrove right at the coast of the Semantics, a large language ocean.</p>
						</div>
					</div>
				</div>
			</div>
			<div><!-- 회원가입 form -->
			<h1>회원가입</h1>
				<form action = "<%=request.getContextPath()%>/member/insertMemberAction.jsp" method="post"> 
					<div>
					<%
						if(request.getParameter("msg")!=null){
					%>
							<div><%=request.getParameter("msg")%></div>
					<% 		
						}
					%>
					</div>
					<table class="table table-hover">
						<tr>
							<th class="table-info">아이디</th>
							<td><input type="text" name="memberId"></td>
						</tr>
						<tr>
							<th class="table-info">비밀번호</th>
							<td><input type="password" name="memberPw"></td>
						</tr>
						<tr>
							<th class="table-info">비밀번호 확인</th>
							<td><input type="password" name="memberPwCk"></td>
						</tr>
					</table>
					<button type = "submit">회원가입</button>
				</form>	
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