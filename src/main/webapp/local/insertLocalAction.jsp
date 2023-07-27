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
	String msg= null;
	if(request.getParameter("localName")==null
	   ||request.getParameter("localName").equals("")){ 
	   msg= URLEncoder.encode("지역명을 입력하세요.","utf-8"); 
		response.sendRedirect(request.getContextPath()+"/insertLocalForm.jsp?msg="+msg);
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
	PreparedStatement insertLocalStmt = null;
	PreparedStatement localCkStmt = null;
	ResultSet rs = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	String insertLocalSql = "INSERT INTO local(local_name, createdate, updatedate) VALUES (?, NOW(),NOW())";
	insertLocalStmt = conn.prepareStatement(insertLocalSql);
	insertLocalStmt.setString(1,localName);
	System.out.println(insertLocalStmt+"<--insertLocalAction stmt");
	
	//local 중복확인용 쿼리
	String sql2 = "SELECT local_name FROM local where local_name=?";
	localCkStmt = conn.prepareStatement(sql2);
	localCkStmt.setString(1,localName);
	System.out.println(localCkStmt+"<--localCkStmt(아이디 중복확인용)");
	rs =localCkStmt.executeQuery();
	
	if(rs.next()){ //if(rs.next())는 ResultSet 객체의 next() 메소드를 사용하여 결과셋이 있으면 true를 반환하고, 결과셋이 없으면 false를 반환 
		//즉, 이 조건문은 DB에서 조회한 결과셋이 존재하는지 여부를 판단
		msg= URLEncoder.encode("중복된 지역입니다.","utf-8");
		response.sendRedirect(request.getContextPath()+"/insertLocalForm.jsp?msg="+msg);
		return;	
	}
	
	int row =insertLocalStmt.executeUpdate(); // 디버깅 1이면 1행입력성공, 0이면 입력된 행이 없다 (excuteUpdate반환값)	
	if(row == 1){
		System.out.println("등록성공");
	}
	response.sendRedirect(request.getContextPath()+"/localList.jsp");
%>