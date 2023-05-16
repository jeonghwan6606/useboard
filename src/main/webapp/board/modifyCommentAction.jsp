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
	//boardNo 체크
	
	System.out.println(request.getParameter("boardNo")+"<--modifyComment boardNo");
	System.out.println(request.getParameter("commentAction")+"<--modifyComment commentAction");
	System.out.println(request.getParameter("commentNo")+"<--modifyComment commentNo");
	
	if(request.getParameter("boardNo")==null){
      response.sendRedirect(request.getContextPath() + "/home.jsp");
      return;
   }
	
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	
	//commentNo 체크
	
	if(request.getParameter("commentNo")==null){
      response.sendRedirect(request.getContextPath() + "/boardOne2.jsp?boardNo="+boardNo);
	}
      
  	int commentNo = Integer.parseInt(request.getParameter("commentNo"));  
  	System.out.println(commentNo+"<--int commentNo"); 
  	
	
  	String commentAction = null;
	//commentAction 가져와서 보내주기(boardOne 뷰 분기문에 사용)
	if(request.getParameter("commentAction")!=null){
		commentAction =request.getParameter("commentAction");
		 response.sendRedirect(request.getContextPath() + "/boardOne2.jsp?commentAction="+commentAction+"&boardNo="+boardNo+"&commentNo="+commentNo);
	      return;
	}

	// commentContent 체크 
	 String msg= null;
		 if(request.getParameter("commentContent")==null
				   ||request.getParameter("commentContent").equals("")){
					 msg= URLEncoder.encode("입력사항(빈칸)을 확인해주세요.","utf-8");
					 commentAction =request.getParameter("commentAction");
					 response.sendRedirect(request.getContextPath()+"/boardOne2.jsp?boardNo="+boardNo+"&commentNo="+commentNo+"&msg="+msg);
					return;
		}
		
	 String commentContent = request.getParameter("commentContent");
	 
	 System.out.println(request.getParameter("commentContent")+"<--modifyComment commentContent");
	 
	
	//2.모델계층
	
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
		
		String sql = "UPDATE comment SET comment_content = ?, updatedate= now() where board_no = ? and comment_no= ?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1,commentContent);
		stmt.setInt(2,boardNo);
		stmt.setInt(3,commentNo);
		System.out.println(stmt+"<--modifyComment stmt");
		
		int row =stmt.executeUpdate(); // 디버깅 1이면 1행입력성공, 0이면 입력된 행이 없다 (excuteUpdate반환값)	
		if(row == 1){
			System.out.println("댓글 수정 성공");
			msg= URLEncoder.encode("수정된 댓글이 저장되었습니다..","utf-8");
		}else{
			System.out.println("댓글 수정 실패");
			msg= URLEncoder.encode("입력사항(빈칸)을 확인해주세요.","utf-8");	
			response.sendRedirect(request.getContextPath()+"/boardOne2.jsp?boardNo="+boardNo+"&msg="+msg);
			return;
		}
		response.sendRedirect(request.getContextPath()+"/boardOne2.jsp?boardNo="+boardNo+"&msg="+msg);
%>
	