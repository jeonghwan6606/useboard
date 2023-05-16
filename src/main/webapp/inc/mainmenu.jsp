<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    

   
<div>
<nav id="colorlib-main-menu" role="navigation">
	<ul>
		<li class="colorlib-active"><a  href="<%=request.getContextPath()%>/home.jsp">홈으로</a></li>
		
		<!-- 로그인전: 회원가입  
		
			로그인 후 : 내정보, 로그아웃(로그인정보 세션 loginMemberId -->
			
		<%
			if(session.getAttribute("loginMemberId")==null){
		%>
				<li class="colorlib-active"><a href="<%=request.getContextPath()%>/insertMemberForm.jsp">회원가입</a></li>
		
		<%		
			}else{
		%>	
				<li class="colorlib-active"><a  role="button" href="<%=request.getContextPath()%>/memberInfo.jsp">회원정보</a></li>
				<li class="colorlib-active"><a  role="button" href="<%=request.getContextPath()%>/member/logoutAction.jsp">로그아웃</a></li>
				<li class="colorlib-active"><a  role="button" href="<%=request.getContextPath()%>/localList.jsp">지역관리</a></li>
				<li class="colorlib-active"><a  role="button" href="<%=request.getContextPath()%>/addBoard.jsp">글쓰기</a></li>
		<% 	
			}
		%>		
	</ul>
</nav>  	
</div>
