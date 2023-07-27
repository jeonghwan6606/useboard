<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<%
	//세션 유효성 검사
	if(session.getAttribute("loginMemberId") != null){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}	
	
	//요청값 유효성 검사
	 if(request.getParameter("memberId")==null
	   ||request.getParameter("memberPw")==null
	   ||request.getParameter("memberPwCk")==null
	   ||request.getParameter("memberPw").equals("") 
	   ||request.getParameter("memberId").equals("")
	   ||request.getParameter("memberPwCk").equals("")){
		// 현재 웹 애플리케이션의 컨텍스트 경로(Context Path)를 문자열로 반환-->
		//웹 애플리케이션의 경로가 변경되어도 자동으로 업데이트되므로 유지보수에 용이-->	
		response.sendRedirect(request.getContextPath()+"/insertMemberForm.jsp");
		return;
	 }
	
	//요청값 변환하기
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	String memberPwCk = request.getParameter("memberPwCk");

	

	System.out.println(memberId+"<--insertMemberAction memberId");
	System.out.println(memberPw+"<--insertMemberAction memberPw");
	System.out.println(memberPwCk+"<--insertMemberAction memberPwCk");
	
	//비밀번호 재확인 메시지 조건 및 문구 
	String msg= null;
	if(!memberPw.equals(memberPwCk)){ //equals를 통해서 값자체를 비교
		msg= URLEncoder.encode("비밀번호를 확인하세요.","utf-8");
		response.sendRedirect(request.getContextPath()+"/insertMemberForm.jsp?msg="+msg);
		System.out.println("비밀번호 중복 메시지");
		return;	
	}	
	//이후에도 사용하기 편하도록 캡슐화된 class이용
	Member paramMember = new Member();
	paramMember.setMemberId(memberId);
	paramMember.setMemberPw(memberPw);
	
	//디버깅
	String driver="org.mariadb.jdbc.Driver";
	String dburl="jdbc:mariadb://3.38.38.146/userboard";
	String dbuser="root";
	String dbpw = "java1234";
	Class.forName(driver);
	System.out.println("<--드라이버 접속성공");
	Connection conn = null;
	PreparedStatement stmt = null;
	PreparedStatement stmt2 = null;
	ResultSet rs = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	String sql = "INSERT INTO member(member_id, member_pw, createdate, updatedate) VALUES (?, PASSWORD(?),NOW(),NOW())";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1,paramMember.getMemberId());
	stmt.setString(2,paramMember.getMemberPw());
	System.out.println(stmt+"<--insertMemberAction stmt");
	
	//아이디 중복확인용 쿼리
	String sql2 = "SELECT member_id FROM member where member_id=?";
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1,paramMember.getMemberId());
	System.out.println(stmt2+"<--insertMemberAction stmt2(아이디 중복확인용)");
	rs =stmt2.executeQuery();
	
	//아이디 중복 조건 및 문구 
	if(rs.next()){ //if(rs.next())는 ResultSet 객체의 next() 메소드를 사용하여 결과셋이 있으면 true를 반환하고, 결과셋이 없으면 false를 반환 
		//즉, 이 조건문은 DB에서 조회한 결과셋이 존재하는지 여부를 판단
		msg= URLEncoder.encode("중복된 아이디입니다.","utf-8");
		response.sendRedirect(request.getContextPath()+"/insertMemberForm.jsp?msg="+msg);
		return;	
	}
	
	int row =stmt.executeUpdate(); // 디버깅 1이면 1행입력성공, 0이면 입력된 행이 없다 (excuteUpdate반환값)	
	if(row == 1){
		System.out.println("회원가입 성공");
	}
	response.sendRedirect(request.getContextPath()+"/employeeList.jsp");
%>