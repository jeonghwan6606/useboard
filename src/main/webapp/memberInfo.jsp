<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "vo.*" %>
<%@ page import = "java.sql.*" %>    
<%
//요청값 분석
if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}

//1. 요청분석(컨트롤러 계층)
	
//1-2) 요청값 변환하기 및 디버깅
	String memberId = (String)session.getAttribute("loginMemberId");
	String memberPw = request.getParameter("memberPw");
	
	if(request.getParameter("memberPw")==null
		||request.getParameter("memberPw").equals("")){
		 memberPw = null;
	}
	
	System.out.println(memberId+"<--memberInfo memberId");
	System.out.println(memberPw+"<--memberInfo memberPw");

//캡슐화 된 Member class 타입으로 paramMember 객체 설정하기	
	Member paramMember = new Member();
	paramMember.setMemberId(memberId);


//2. 모델 계층
	String driver="org.mariadb.jdbc.Driver";
	String dburl="jdbc:mariadb://3.38.38.146/userboard";
	String dbuser="root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement memberInfoStmt = null ;
	ResultSet memberInfoRs = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	
	String sql = "SELECT member_id memberId FROM member WHERE member_id = ?";
	memberInfoStmt = conn.prepareStatement(sql);
	memberInfoStmt.setString(1,paramMember.getMemberId());
	System.out.println(memberInfoStmt+"<--memberInfo stmt");
	memberInfoRs =memberInfoStmt.executeQuery();

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
							<h1 class="mb-4">프로젝트설명(~5.9)</h1>
							<p class="mb-4">I am A Blogger Far far away, behind the word mountains, far from the countries Vokalia and Consonantia, there live the blind texts. Separated they live in Bookmarksgrove right at the coast of the Semantics, a large language ocean.</p>
						</div>
					</div>
				</div>
			</div>
			<div>
			<h1>회원 정보</h1>
			<br>
			<div>
			<!--ㅡmemberinfo form-->
			<form action="<%=request.getContextPath()%>/member/memberInfoAction.jsp" method="post">
				<table class="table table-hover">			
					<tr>
						<th class="table-info"> 아이디</th>
						<%
							if(memberInfoRs.next()){
								Member m = new Member();
								m.setMemberId(memberInfoRs.getString("memberId"));
						%>
									<th><%=m.getMemberId()%></th>
						<%
							}
						%>
					
					</tr>
					<%
						if(memberPw==null){
					%>		
							<tr>
								<th class="table-info"> 비밀번호</th>
								<th><input type="password" name="memberPw"> <button class="btn btn-outline-dark" type="submit">확인</button></th>								
							</tr>	
						<% 
							}
						%>	
				 </table>	
			</form>
				
			<form action="<%=request.getContextPath()%>/member/updateMemberAction.jsp">	
				<table class="table table-hover">
					<%
						if(memberPw!=null){
					%>	
							<tr>
								<th colspan="2"><font size="5">정보수정</font></th>
							</tr>	
							<tr>
								<th class="table-info"> 현재 비밀번호</th>
								<th colspan="2"><input type="text" name="memberPw" value=<%=memberPw%> readonly="readonly"></th>
							</tr>	
							<tr>
								<th class="table-info"> 새 비밀번호</th>
								<th colspan="2"><input type="password" name="newMemberPw" ></th>
							</tr>
							<tr>
								<th class="table-info"> 비밀번호 확인</th>
								<th><input type="password" name="newMemberPw2" ></th>
								<%
									if(request.getParameter("msg")!=null){
								%>
										<th><%=request.getParameter("msg")%></th>
								<% 		
									}
								%>
							</tr>
							<tr>
								<td colspan="3"><button class="btn btn-outline-dark" type="submit">비밀번호 수정</button></td>
							</tr>
				</table>
			</form>	
			<form action="<%=request.getContextPath()%>/member/deleteMemberAction.jsp">
				<table class="table table-hover">		
							<tr>
								<th colspan="2"><font size="5">회원탈퇴</font></th>
							</tr>	
							<tr>
								<th class="table-info">탈퇴사유</th>
								<td colspan="2">
									<select>
										<option value="reason"> ==선택==</option>
										<option value="reason1"> 이용이 불편합니다.</option>
										<option value="reason2"> 다른 사이트 이용</option>
										<option value="reason3"> 필요없어졌습니다.</option>
									</select>
								</td>
							</tr>
							<tr>
								<th class="table-info"> 현재 비밀번호</th>
								<th colspan="2"><input type="password" name="memberPw" value=<%=memberPw%> readonly="readonly"></th>
							</tr>	
							<tr>
								<th class="table-info">비밀번호 확인</th>	
								<th colspan="2"><input type="password" name="memberPwCk">
								
									<%
										if(request.getParameter("msg2")!=null){
									%>
											<%=request.getParameter("msg2")%>
									<% 		
										}
									%>
							
							    </th>										
							</tr>
							<tr>
								<td colspan="3">
									<button class="btn btn-danger" type="submit">회원탈퇴</button>
								</td>
							</tr>				
						<%
							}
						%>							
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