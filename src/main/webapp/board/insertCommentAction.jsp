<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>    
<%
	//1. 요청분석(컨트롤러 계층)
	//1-1.세션 유효성 검사
    if(session.getAttribute("loginMemberId")==null){
    	response.sendRedirect(request.getContextPath()+"/home.jsp");
    	return;
    }
    
	//1-2.요청값 유효성 검사
	if(request.getParameter("boardNo")==null){
		response.sendRedirect(request.getContextPath()+"/home.jsp");
		return;
	} 
	
	if(request.getParameter("commentContent")==null
			||request.getParameter("commentContent").equals("")){
		response.sendRedirect(request.getContextPath()+"/boardOne2.jsp?boardNo="+request.getParameter("boardNo"));
		return;
	}
	
	//1-3 요청값 변환하여 가져오기
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	String commentContent = request.getParameter("commentContent");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	
	//2. 모델계층
	String driver="org.mariadb.jdbc.Driver";
	String dburl="jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser="root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	
	//2-1) 서브메뉴 결과셋(모델) 
	PreparedStatement insertCommentStmt = null ;
	ResultSet insertCommentRs = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
		/*
			"INSERT INTO comment(member_id, comment_content,createdate,updatedate) VALUES (?, ?,NOW(),NOW())";
		*/
	String insertCommentSql = "INSERT INTO comment(member_id,board_no, comment_content,createdate,updatedate) VALUES (?,?, ?,NOW(),NOW())";
	insertCommentStmt = conn.prepareStatement(insertCommentSql);
	insertCommentStmt.setString(1, loginMemberId);
	insertCommentStmt.setInt(2, boardNo);
	insertCommentStmt.setString(3, commentContent);
	System.out.println(insertCommentStmt+"<--insertCommentAction insertCommentStmt");
	
	int insertCommentRow = insertCommentStmt.executeUpdate(); //영향받은 행 반환값
	if(insertCommentRow == 1){
		System.out.println("댓글입력성공");
	response.sendRedirect(request.getContextPath()+"/boardOne2.jsp?boardNo="+boardNo);		
	}else{
		System.out.println("댓글입력실패");
		response.sendRedirect(request.getContextPath()+"/boardOne2.jsp"+boardNo);	
	}
	
%>