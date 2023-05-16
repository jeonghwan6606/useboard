<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<%
	//1.요청분석
	//세션 유효성 검사
	if(session.getAttribute("loginMemberId")== null){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}	


	//요청값 유효성 검사
	
	if(request.getParameter("localName")==null){
		response.sendRedirect(request.getContextPath() + "/localList.jsp");
		return;
	}
	//디버깅
	System.out.println(request.getParameter("localName")+"localName");
	
	
	String msg= null;
	if(request.getParameter("newlocalName")==null
	   ||request.getParameter("newlocalName").equals("")){	
	   msg= URLEncoder.encode("지역명을 입력하세요.","utf-8"); 
		response.sendRedirect(request.getContextPath()+"/updateLocalForm.jsp?localName="+URLEncoder.encode((String)request.getParameter("localName"),"utf-8")
		+"&msg="
		+msg);
		return;
	 }
	
	//디버깅
	System.out.println(request.getParameter("newlocalName")+"newlocalName");
	
	//요청값 변환하기
	String newlocalName = request.getParameter("newlocalName");	
	String localName = request.getParameter("localName");
	
	//2.모델계층
	String driver="org.mariadb.jdbc.Driver";
	String dburl="jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser="root";
	String dbpw = "java1234";
	Class.forName(driver);
	System.out.println("<--드라이버 접속성공");
	Connection conn = null;
	PreparedStatement updateLocalStmt = null;
	PreparedStatement localCkStmt = null;
	PreparedStatement boardCkStmt = null;
	ResultSet boardCkRs = null;
	ResultSet localCkRs = null;
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
		msg= URLEncoder.encode("해당 지역의 게시판을 확인하세요.","utf-8");
		response.sendRedirect(request.getContextPath()+"/updateLocalForm.jsp?localName="+URLEncoder.encode((String)request.getParameter("localName"),"utf-8")
		+"&msg="
		+msg);
		return;
	 }
	}
	
	//2-2) 중복확인용 쿼리 
	String localCkSql = "SELECT local_name FROM local where local_name=?";
	localCkStmt = conn.prepareStatement(localCkSql);
	localCkStmt.setString(1,newlocalName);
	
	System.out.println(localCkStmt+"<--localCkStmt(지역 중복확인용)");
	localCkRs =localCkStmt.executeQuery();
	System.out.println(localCkStmt+"<--insertLocalAction stmt"); 
	
	if(localCkRs.next()){
		msg= URLEncoder.encode("중복된 지역입니다.","utf-8");
		response.sendRedirect(request.getContextPath()+"/updateLocalForm.jsp?localName="+URLEncoder.encode((String)request.getParameter("localName"),"utf-8")
		+"&msg="
		+msg);
		return;
	 }

	//2-3) updateLocal 쿼리
	String updateLocalSql = "UPDATE local  SET updatedate = now(), local_name = ? where local_name = ?";
	updateLocalStmt = conn.prepareStatement(updateLocalSql);
	updateLocalStmt.setString(1,newlocalName);
	updateLocalStmt.setString(2,localName);
	System.out.println(updateLocalStmt+"<--updateLocalAction stmt");
	
	
	int row =updateLocalStmt.executeUpdate(); // 디버깅 1이면 1행입력성공, 0이면 입력된 행이 없다 (excuteUpdate반환값)	
	if(row == 1){
		System.out.println("수정성공");
	}
	response.sendRedirect(request.getContextPath()+"/localList.jsp");
%>