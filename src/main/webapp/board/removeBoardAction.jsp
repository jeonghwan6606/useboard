<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
//1.요청분석
	//세션 유효성 검사
	if(session.getAttribute("loginMemberId")== null){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}	

	//요청값 유효성 검사
	
		if(request.getParameter("boardNo")==null){
	    response.sendRedirect(request.getContextPath() + "/home.jsp");
	    return;
	 }
		
		
		int boardNo = Integer.parseInt(request.getParameter("boardNo"));
		
//2.모델계층
	String driver="org.mariadb.jdbc.Driver";
	String dburl="jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser="root";
	String dbpw = "java1234";
	Class.forName(driver);
	System.out.println("<--드라이버 접속성공");
	Connection conn = null;
	PreparedStatement deleteBoardStmt = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);	

//"delete from local where local_name= ?";	
//2-2) deleteLocal 쿼리
	String deleteLocalSql = "delete from board where board_no= ?";
	deleteBoardStmt = conn.prepareStatement(deleteLocalSql);
	deleteBoardStmt.setInt(1,boardNo);
	System.out.println(deleteBoardStmt+"<--deleteLocalStmt");
		
		
	int row =deleteBoardStmt.executeUpdate(); // 디버깅 1이면 1행입력성공, 0이면 입력된 행이 없다 (excuteUpdate반환값)	
	if(row == 1){
		System.out.println("삭제성공");
	}else{
		System.out.println("삭제실패");
	}
	response.sendRedirect(request.getContextPath()+"/home.jsp");	
%>