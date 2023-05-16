<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %> 
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<%	
	//요청분석
	//1. 유효성 검사
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return;
	}

	if(request.getParameter("memberPw")==null
	||request.getParameter("memberPw").equals("")){
		response.sendRedirect(request.getContextPath()+"/memberInfo.jsp");
		return;
	}
	String msg= null;
	 if(request.getParameter("newMemberPw")==null
	   ||request.getParameter("newMemberPw2")==null
	   ||request.getParameter("newMemberPw").equals("") 
	   ||request.getParameter("newMemberPw2").equals("")){
		 msg= URLEncoder.encode("비밀번호를 설정해주세요.","utf-8");
		 String memberId = (String)session.getAttribute("loginMemberId");
		 String memberPw = request.getParameter("memberPw");
		 response.sendRedirect(request.getContextPath()+"/memberInfo.jsp?memberId="+memberId+"&memberPw="+memberPw+"&msg="+msg);
		return;
	 }
	
	//1-1. 객체값 변환하기
	String memberId = (String)session.getAttribute("loginMemberId");
	String memberPw = request.getParameter("memberPw");
	String newMemberPw = request.getParameter("newMemberPw");
	String newMemberPw2 = request.getParameter("newMemberPw2");
	
	//디버깅 변환값
	System.out.println(memberId+"<--insertMemberAction memberId");
	System.out.println(memberId+"<--insertMemberAction memberPw");
	System.out.println(newMemberPw +"<--insertMemberAction newmemberPw");
	System.out.println(newMemberPw2+"<--insertMemberAction newmemberPw2");
	
	//비밀번호 재확인 메시지 조건 및 문구 
		
		if(!newMemberPw.equals(newMemberPw2)){ //equals를 통해서 값자체를 비교
			msg= URLEncoder.encode("비밀번호가 일치하지 않습니다.","utf-8");
			response.sendRedirect(request.getContextPath()+"/memberInfo.jsp?memberId="+memberId+"&memberPw="+memberPw+"&msg="+msg);
			System.out.println("비밀번호가 일치하지 않습니다.");
			return;	
		}
	
	//이후에도 사용하기 편하도록 캡슐화된 class이용
		Member paramMember = new Member();
		paramMember.setMemberId(memberId);
		paramMember.setMemberPw(memberPw);
	
	//2. 모델계층
	
	String driver="org.mariadb.jdbc.Driver";
	String dburl="jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser="root";
	String dbpw = "java1234";
	Class.forName(driver);
	System.out.println("<--드라이버 접속성공");
	Connection conn = null;
	PreparedStatement updateInfStmt = null;
	ResultSet updateInfRs = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	////"UPDATE member SET member_pw= ?, updatedate=now() where member_id=? and member_pw=?";
	String updateInfSql = "UPDATE member SET member_pw= PASSWORD(?), updatedate=now() where member_id=? and member_pw= Password(?)";
	updateInfStmt = conn.prepareStatement(updateInfSql);
	updateInfStmt.setString(1,newMemberPw);
	updateInfStmt.setString(2,paramMember.getMemberId());
	updateInfStmt.setString(3,paramMember.getMemberPw());
	System.out.println(updateInfStmt+"<--updateInfStmt");
	
	int row =updateInfStmt.executeUpdate(); // 디버깅 1이면 1행입력성공, 0이면 입력된 행이 없다 (excuteUpdate반환값)	
	if(row == 1){
		System.out.println("비밀번호 변경 성공");
	}
	response.sendRedirect(request.getContextPath()+"/home.jsp");
	
%>