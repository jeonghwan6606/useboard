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
	if(request.getParameter("localName")==null
	   ||request.getParameter("localName").equals("")){ 
		response.sendRedirect(request.getContextPath()+"/localList.jsp");
		return;
	}
	
	//요청값 변환하기
		String localName = request.getParameter("localName");		
		System.out.println(localName+"<--insertLocalAction localName");
		
	//2.모델계층
		String driver="org.mariadb.jdbc.Driver";
		String dburl="jdbc:mariadb://3.38.38.146/userboard";
		String dbuser="root";
		String dbpw = "java1234";
		Class.forName(driver);
		System.out.println("<--드라이버 접속성공");
		Connection conn = null;
		PreparedStatement deleteLocalStmt = null;
		PreparedStatement boardCkStmt = null;
		ResultSet boardCkRs = null;
		conn = DriverManager.getConnection(dburl, dbuser, dbpw);	
		
	//2-1) board확인용 쿼리 
		String boardCkSql = "SELECT  COUNT(local_name) cnt FROM board WHERE local_name = ?" ;
		boardCkStmt = conn.prepareStatement(boardCkSql);
		boardCkStmt.setString(1,localName);
		System.out.println(boardCkStmt+"<--boardCkStmt(게시판 글 확인용)");
		boardCkRs =boardCkStmt.executeQuery();
		int cnt = 0;
		if(boardCkRs.next()){ 
			cnt = boardCkRs.getInt("cnt");
			if(cnt>0){
			response.sendRedirect(request.getContextPath()+"/localList.jsp");
			return;
		 	}
		}
			
	//"delete from local where local_name= ?";	
	//2-2) deleteLocal 쿼리
	String deleteLocalSql = "delete from local where local_name= ?";
	deleteLocalStmt = conn.prepareStatement(deleteLocalSql);
	deleteLocalStmt.setString(1,localName);
	System.out.println(deleteLocalStmt+"<--deleteLocalStmt");
	
	
	int row =deleteLocalStmt.executeUpdate(); // 디버깅 1이면 1행입력성공, 0이면 입력된 행이 없다 (excuteUpdate반환값)	
	if(row == 1){
		System.out.println("삭제성공");
	}else{
		System.out.println("삭제실패");
	}
	response.sendRedirect(request.getContextPath()+"/localList.jsp");
%>