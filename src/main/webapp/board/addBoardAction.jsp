<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<% 
    //1.요청분석
    //세션 유효성 검사
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}	
	
	//요청값 유효성 검사
	 if(request.getParameter("memberId")==null
	   ||request.getParameter("memberId").equals("")){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	 }
	
	System.out.println(request.getParameter("localName")+"<--addBoard localName");
	System.out.println(request.getParameter("boardTitle")+"<--addBoard boardTitle");
	System.out.println(request.getParameter("boardContent")+"<--addBoard boardContent");
	
	 String msg= null;
	 if(request.getParameter("localName")==null
			   ||request.getParameter("boardContent")==null
			   ||request.getParameter("boardTitle")==null
			   ||request.getParameter("localName").equals("")
			   ||request.getParameter("boardTitle").equals("")
			   ||request.getParameter("boardContent").equals("")){
				 msg= URLEncoder.encode("입력사항(빈칸)을 확인해주세요.","utf-8");	
				response.sendRedirect(request.getContextPath()+"/addBoard.jsp?msg="+msg);
				return;
	}
	
	
	//요청값 변환하기
	String memberId = request.getParameter("memberId");
	String localName = request.getParameter("localName");
	String boardContent = request.getParameter("boardContent");
	String boardTitle = request.getParameter("boardTitle");
	

	System.out.println(memberId+"<--addBoard memberId");
	System.out.println(localName+"<--addBoard localName");
	System.out.println(boardContent+"<--addBoard boardContent");
	System.out.println(boardTitle+"<--addBoard boardTitle");
	
	
	//2. 모델 계층 
	String driver="org.mariadb.jdbc.Driver";
	String dburl="jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser="root";
	String dbpw = "java1234";
	Class.forName(driver);
	System.out.println("<--드라이버 접속성공");
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	String sql = "INSERT INTO board(member_id, local_name, board_title, board_content, createdate, updatedate) VALUES (?, ?,?,?,NOW(),NOW())";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1,memberId);
	stmt.setString(2,localName);
	stmt.setString(3,boardTitle);
	stmt.setString(4,boardContent);
	System.out.println(stmt+"<--addBoard stmt");
	
	int row =stmt.executeUpdate(); // 디버깅 1이면 1행입력성공, 0이면 입력된 행이 없다 (excuteUpdate반환값)	
	if(row == 1){
		System.out.println("게시글 작성 성공");
	}else{
		System.out.println("게시글 작성 실패");
		msg= URLEncoder.encode("입력사항(빈칸)을 확인해주세요.","utf-8");	
		response.sendRedirect(request.getContextPath()+"/addBoard.jsp?msg="+msg);
		return;
	}
	response.sendRedirect(request.getContextPath()+"/home.jsp");
%>	