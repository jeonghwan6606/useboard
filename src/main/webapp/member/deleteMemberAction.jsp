<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %> 
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<% 
//DELETE CASCADE는 SQL에서 외래 키 관계를 설정할 때 사용되는 옵션
// 옵션을 설정하면 부모 테이블에서 행을 삭제할 때, 해당 행을 참조하는 자식 테이블의 행도 자동으로 삭제

//1.요청분석-유효성검사
	if(session.getAttribute("loginMemberId") == null
		||request.getParameter("memberPw")==null
		){
			response.sendRedirect(request.getContextPath() + "/home.jsp");
			return;
	}

	String msg2 =null;
	if(request.getParameter("memberPwCk")==null
			||request.getParameter("memberPwCk").equals("")){
			msg2= URLEncoder.encode("비밀번호를 확인해주세요","utf-8");
		 String memberId = (String)session.getAttribute("loginMemberId");
		 String memberPw = request.getParameter("memberPw");
		 response.sendRedirect(request.getContextPath()+"/memberInfo.jsp?memberId="+memberId+"&memberPw="+memberPw+"&msg2="+msg2);
		return;
	}
	
//1-2.요청값 변환하기 
	String memberId = (String)session.getAttribute("loginMemberId"); //세션에서 가져와 string으로 변환
	String memberPwCk = request.getParameter("memberPwCk");
	String memberPw = request.getParameter("memberPw");
	
	System.out.println(memberId+"<--deleteMemberAction memberId");
	System.out.println(memberPwCk+"<--deleteMemberAction memberPwCk");
	
//2.모델 계층
	String driver="org.mariadb.jdbc.Driver";
	String dburl="jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser="root";
	String dbpw = "java1234";
	Class.forName(driver);
	System.out.println("<--드라이버 접속성공");
	Connection conn = null;
	PreparedStatement deleteMemberStmt = null;
	ResultSet deleteMemberRs = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	
//2-1) 회원탈퇴 쿼리
	String deleteMemberSql = "DELETE FROM member WHERE member_id = ? AND member_Pw = PASSWORD(?)";
	deleteMemberStmt = conn.prepareStatement(deleteMemberSql);
	deleteMemberStmt.setString(1,memberId);
	deleteMemberStmt.setString(2,memberPwCk);
	System.out.println(deleteMemberStmt+"<--deleteMemberAction stmt");
	
	
	int row =deleteMemberStmt.executeUpdate();
	if(row == 1){
		System.out.println("회원탈퇴 성공");
		session.invalidate();//기존 세션을 지우고 갱신
	} else{//비밀번호 불일치시
		msg2= URLEncoder.encode(" 회원탈퇴 실패(비밀번호 불일치)","utf-8");
	 response.sendRedirect(request.getContextPath()+"/memberInfo.jsp?memberId="+memberId+"&memberPw="+memberPw+"&msg2="+msg2);
	return;
}
	response.sendRedirect(request.getContextPath()+"/home.jsp");

%>


    