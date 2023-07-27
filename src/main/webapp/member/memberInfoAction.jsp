<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "vo.*" %>
<%@ page import = "java.sql.*" %>    
<%
   
   //요청값 분석
   //1. 요청분석(컨트롤러 계층)
   //1-1)  유효성 검사

   if(request.getParameter("memberPw")==null
         ||request.getParameter("memberPw").equals("")){
	   response.sendRedirect(request.getContextPath() + "/memberInfo.jsp");
	   
	   return;
   }
   
   //1-2) 요청값 변환하기 및 디버깅
   String memberId = (String)session.getAttribute("loginMemberId");
   String memberPw = request.getParameter("memberPw");
   
   System.out.println(memberId+"<--memberInfo memberId");
   System.out.println(memberPw+"<--memberInfo memberPw");
   
   //캡슐화 된 Member class 타입으로 paramMember 객체 설정하기   
   Member paramMember = new Member();
   paramMember.setMemberId(memberId);
   paramMember.setMemberPw(memberPw);
   
   String driver="org.mariadb.jdbc.Driver";
   String dburl="jdbc:mariadb://3.38.38.146/userboard";
   String dbuser="root";
   String dbpw = "java1234";
   Class.forName(driver);
   Connection conn = null;
   PreparedStatement memberInfoStmt = null ;
   ResultSet memberInfoRs = null;
   conn = DriverManager.getConnection(dburl, dbuser, dbpw);
   
   String sql = "SELECT member_id memberId, member_pw memberPw FROM member WHERE member_id = ? and member_pw = PASSWORD(?)";
   memberInfoStmt = conn.prepareStatement(sql);
   memberInfoStmt.setString(1,paramMember.getMemberId());
   memberInfoStmt.setString(2,paramMember.getMemberPw());
   System.out.println(memberInfoStmt+"<--memberInfo stmt");
   memberInfoRs =memberInfoStmt.executeQuery();
   if(memberInfoRs.next()){
      System.out.println("회원정보 조회 성공 :"+session.getAttribute("loginMemberId"));
      System.out.println("회원정보 조회 성공 :"+request.getParameter("memberPw"));
   }else{
      System.out.println("회원정보 조회 실패 :"+session.getAttribute("loginMemberId"));
      System.out.println("회원정보 조회 실패 :"+request.getParameter("memberPw"));
      response.sendRedirect(request.getContextPath()+"/memberInfo.jsp?memberId="+memberId);
   	
      return; //틀릴경우엔 조회 memberPw를 null값으로 보내기
   }
   
   response.sendRedirect(request.getContextPath()+"/memberInfo.jsp?memberId="+memberId+"&memberPw="+memberPw);
%>
