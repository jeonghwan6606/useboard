<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<% 

	//1.요청분석
	//세션 유효성 검사

	String loginMemberId = (String)session.getAttribute("loginMemberId");
	
   // 유효성 검사
   if(request.getParameter("boardNo")==null){
      response.sendRedirect(request.getContextPath() + "/home.jsp");
      return;
   }
   
   String commentAction = null; //commentAction 초기화
   if(request.getParameter("commentAction")!=null){
	      commentAction = request.getParameter("commentAction");
   }
   
   
   System.out.println(request.getParameter("commentNo")+"<-boardOne2 commentNo");
   int commentNo = 0;
   if(request.getParameter("commentNo")!=null){
	      commentNo = Integer.parseInt(request.getParameter("commentNo"));
	}		   
  
   int currentPage = 1;
   if(request.getParameter("currentPage")!=null){
      currentPage = Integer.parseInt(request.getParameter("currentPage"));
   }
   System.out.println(currentPage+"<-currentpage");
   int rowPerPage = 10;
   int startRow =  (currentPage-1)*rowPerPage; 
   //String 형태로 요청값 변환하기
   int boardNo = Integer.parseInt(request.getParameter("boardNo"));
      
   ////2. 모델계층
   String driver="org.mariadb.jdbc.Driver";
   String dburl="jdbc:mariadb://127.0.0.1:3306/userboard";
   String dbuser="root";
   String dbpw = "java1234";
   Class.forName(driver);
   Connection conn = null;
   
   //2-1) 서브메뉴 결과셋(모델) 
   PreparedStatement subMenuStmt = null ;
   ResultSet subMenuRs = null;
   conn = DriverManager.getConnection(dburl, dbuser, dbpw);
      /*
       SELECT '전체' localName , COUNT(local_name) cnt FROM board
      UNION ALL
      SELECT local_name, COUNT(local_name) FROM board GROUP BY local_name;
      */
   String subMenuSql = "SELECT '전체' localName , COUNT(local_name) cnt FROM board UNION ALL SELECT local_name, COUNT(local_name) FROM board GROUP BY local_name";
   subMenuStmt = conn.prepareStatement(subMenuSql);
      
   System.out.println(subMenuStmt+"<--loginListByMap stmt");
   subMenuRs =subMenuStmt.executeQuery();
      //HashMap은 Key-Value 쌍의 데이터를 저장하고 검색하는 데 사용, 
      //VO는 데이터를 캡슐화하고 해당 데이터에 접근하는 데 사용됨. 일반적으로 HashMap은 데이터를 저장하는 용도로 사용되고, VO는 데이터를 담는 객체로 사용됩니다 (vo는 불변성 특징을 가짐)
      
      //vo대신 HashMap 타입을 사용
      //subMenuList <--모델데이터 
   ArrayList<HashMap<String, Object>> subMenuList = new ArrayList<HashMap<String, Object>>();
   while(subMenuRs.next()){   
      HashMap<String, Object> m = new HashMap<String, Object>();
      m.put("localName",subMenuRs.getString("localName"));
      m.put("cnt",subMenuRs.getInt("cnt"));
      subMenuList.add(m);
   }
   
   //2-2) boarOne 결과셋(모델)


   // "SELECT board_no, member_id memberId, local_name localName, board_title, board_content, createdate, updatedate From board WHERE board_no = ? ORDER BY createdate desc";
   String boSql = "SELECT board_no, member_id memberId, local_name localName, board_title, board_content, createdate, updatedate From board WHERE board_no = ? ORDER BY createdate desc";
   PreparedStatement boStmt =conn.prepareStatement(boSql);
   boStmt.setInt(1,boardNo);
   
   System.out.println(boStmt+"<--boardOne boStmt");
   ResultSet boRs= boStmt.executeQuery(); // Board type 필요
   
   Board bO = null;  
   if(boRs.next()){
	   bO = new Board();
	   bO.setBoardNo(boRs.getInt("board_no"));
	   bO.setMemberId(boRs.getString("memberId"));
	   bO.setLocalName(boRs.getString("localName"));
	   bO.setBoardTitle(boRs.getString("board_title"));
	   bO.setBoardContent(boRs.getString("board_content"));
	   bO.setCreatedate(boRs.getString("createdate"));
	   bO.setUpdatedate(boRs.getString("updatedate"));
   }
   
   //2-3) comment list 결과셋
   PreparedStatement commentListStmt = null ;
   ResultSet commentListRs = null;
      /*
       SELECT comment_no, board_no, comment_content
		FROM COMMENT
		WHERE board_no = 900
		LIMIT 0,10;
      */
   String commentListSql = "SELECT comment_no, board_no, comment_content, member_id, createdate, updatedate FROM COMMENT WHERE board_no = ? LIMIT ?,?";
  	commentListStmt = conn.prepareStatement(commentListSql);
  	commentListStmt.setInt(1,boardNo);
  	commentListStmt.setInt(2,startRow);
  	commentListStmt.setInt(3,rowPerPage);
  	
   System.out.println(commentListStmt+"<--boardOne commenListStmt");
   commentListRs =commentListStmt.executeQuery();
   ArrayList<Comment> commentList = new ArrayList<Comment>(); 
	while(commentListRs.next()){
		Comment c = new Comment();
		c.setBoardNo(commentListRs.getInt("board_no"));
		c.setCommentNo(commentListRs.getInt("comment_no"));
		c.setCommentContent(commentListRs.getString("comment_content"));
		c.setMemberId(commentListRs.getString("member_id"));
		c.setCreatedate(commentListRs.getString("createdate"));
		c.setUpdatedate(commentListRs.getString("updatedate"));
		commentList.add(c);
	}
%>  
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css?family=Poppins:300,400,500,600,700" rel="stylesheet">
<link href="https://fonts.googleapis.com/css?family=Montserrat:300,400,500,700" rel="stylesheet">

 <link rel="stylesheet" href="css/style.css">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<title>Insert title here</title>
<style>
		.hidden-col { display: none; }
</style>
</head>
<body>
	<div id="colorlib-page">
		<aside id="colorlib-aside" role="complementary" class="js-fullheight text-center">
			<h1 id="colorlib-logo"><a href="index.html">userboard project<span>.</span></a></h1>
			<div>
				<%
					//request.getRequestDispatcher(request.getContextPath()+"/inc/copyright.jsp").include(request, response); // request dispatcher 는 합치는 기능을 가지고 있다. 
					//include 는 a와 b 둘다 보이도록 합치고 forward는 a가 안보이도록 b를 합친다
					// 위에 코드를 액션태그로 변경하면 아래와 같다!
				%>
				<!--<jsp:include page ="/inc/copyright.jsp"></jsp:include>  include는 자바 서버에서 실행되는 부분 request가 필요없다-->
				   
				<!--jsp:include 태그는 다른 JSP 페이지나 HTML 파일 등을 포함시키는 데 사용되는데, 이 태그를 사용하면 지정된 파일의 내용이 현재 JSP 페이지에 포함됨-->
				<!--다만, 외부라이브러리 처럼 사용할 수 있는 action을 사용하면 안써도 된다.-->	
							
				<jsp:include page ="/inc/mainmenu.jsp"></jsp:include>  <!-- 메인메뉴 가로 -->		
			</div>	
			<!-- 서브메뉴 세로 //subMenuList <--모델데이터를 출력 -->
			<div>	
				<!--home 내용: 로그인 form -->
				<!-- 로그인 form-->
				<%
					if(session.getAttribute("loginMemberId")==null){
				%>
					<!-- 현재 웹 애플리케이션의 컨텍스트 경로(Context Path)를 문자열로 반환-->
					<!-- 웹 애플리케이션의 경로가 변경되어도 자동으로 업데이트되므로 유지보수에 용이-->
					
					<form action = "<%=request.getContextPath()%>/member/loginAction.jsp" method="post"> 				
						<div class="login_id">
                			<h4>ID</h4>
                			<input type="text" name="memberId">
           			    </div>
			            <div class="login_pw">
			                <h4>Password</h4>
			                <input type="password" name="memberPw"  placeholder="Password">
			            </div>
						<div class="submit">
               				 <input type="submit" value="로그인">
            			</div>	
					</form>	
		
				<% 	
					}
				%>
			</div>
			<br>
			<div>
				<%
					for(HashMap<String, Object> m : subMenuList) {
				%>
						<li class="colorlib-active">
								<a href="<%=request.getContextPath()%>/home.jsp?localName=<%=(String)m.get("localName")%>">
									<%=(String)m.get("localName")%>(<%=(Integer)m.get("cnt")%>) <!-- (Sting) 형변환, (Integer) 정수 형변환 -->
								</a>
						</li>
				<%		
					}
				%>
			</div>
		</aside>
		<div id="colorlib-main">
			<div class="hero-wrap js-fullheight" style="background-image: url(images/bg_1.jpg);" data-stellar-background-ratio="0.5">
				<div class="overlay"></div>
				<div class="js-fullheight d-flex justify-content-center align-items-center">
					<div class="col-md-8 text text-center">
						<div class="desc">
							<h2 class="subheading">userboard Project</h2>
							<h1 class="mb-4">프로젝트설명</h1>
							<p class="mb-4">차후 설명 추가 예정입니다(2023.05.04)</p>
						</div>
					</div>
				</div>
			</div>
		<div> 
	     <!--3-3)본문 board one 결과셋  --> 
	      <h1>게시글 상세</h1>
	      <% //로그인한 아이디와 게시글 작성자가 일치 할 때만 노출
	      	if(loginMemberId!=null){
	      		if(loginMemberId.equals((String)bO.getMemberId())){
	      %>
			      <article style=" text-align:right;">
				      <a href="<%=request.getContextPath()%>/modifyBoard.jsp?boardNo=<%=bO.getBoardNo()%>" role="button" >수정</a>
				      <a href="<%=request.getContextPath()%>/board/removeBoardAction.jsp?boardNo=<%=bO.getBoardNo()%>" role="button" >삭제</a>
			      </article>
	      <%
	      		}
	      	}
	      %>
	      	<table class="table table-hover">
	      		<tr>
	      			<th class="table-info">제목</th>
	      			<td><%=bO.getBoardTitle()%></td>
	      			<td colspan="4"></td>
	      		</tr>
	      		<tr>
	      			<th class="table-info">번호</th>
	      			<td><%=bO.getBoardNo()%></td>
	      			<th class="table-info">작성일</th>
	      			<td><%=bO.getCreatedate()%></td>
	      			<th class="table-info">업데이트일</th>
	      			<td><%=bO.getUpdatedate()%></td>
	      		<tr>
	      			<th class="table-info">지역</th>
	      			<td><%=bO.getLocalName()%></td>
	      			<th class="table-info">글쓴이</th>
	      			<td><%=bO.getMemberId()%></td>
	      			<td colspan="2"></td>
	      		</tr>
	      		<tr>
	      			<th class="table-info">내용</th>
	      			<td colspan="5"><%=bO.getBoardContent()%></td>
	      		</tr>
	      	</table> 	
	   </div>
	   <div> 
	     <!--3-4)comment list 결과셋  --> 
	      <h3>댓글 목록</h3>
	      	<div>
				<%
					if(request.getParameter("msg")!=null){
				%>
						<font color="red"><%=request.getParameter("msg")%></font>
				<% 		
					}
				%>
			</div>
	      	 <div style="text-align:right;">
				<a href="<%=request.getContextPath()%>/board/boardOne2.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage-1%>">
					이전
				</a>
				<a href="<%=request.getContextPath()%>/board/boardOne2.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage+1%>">
					다음
				</a>
	  		 </div>
	  		<form action = "<%=request.getContextPath()%>/board/modifyCommentAction.jsp"> 
	      	<table class="table table-hover">
	      		<tr class="table-info">
	      			<th>댓글</th>
	      			<th>닉네임</th>
	      			<th>작성일</th>
	      			<th>업데이트일</th>
	      			<th>수정</th>
	      			<th>삭제</th>
	      		</tr>
	      		<% if(commentAction==null){
		      			for(Comment c: commentList){
		      	%>
			      		<tr>
			      			<th><%=c.getCommentContent()%></th>
			      			<th><%=c.getMemberId()%></th>
			      			<th><%=c.getCreatedate()%></th>
			      			<th><%=c.getUpdatedate()%></th>
			    		<% //로그인한 아이디와 댓글글 작성자가 일치 할 때만 노출
					      	if(loginMemberId!=null){
					      		if(loginMemberId.equals((String)c.getMemberId())){
					     %>		      			
			      			<th><a class="btn btn-outline-dark" href="<%=request.getContextPath()%>/board/modifyCommentAction.jsp?commentAction=modify&boardNo=<%=c.getBoardNo()%>&commentNo=<%=c.getCommentNo() %>" role="button">수정</a></th>
			      			<th><a class="btn btn-outline-dark" href="<%=request.getContextPath()%>/board/removeCommentAction.jsp?boardNo=<%=c.getBoardNo()%>&commentNo=<%=c.getCommentNo()%>" role="button">삭제</a></th>
			      		</tr>
		      	<%
					      		}
					      	}
		      			}
	      			}else{		
	      				for(Comment c: commentList){
		      	%>
			      		<tr>
			      			<th class="hidden-col"><input type="hidden" name= "boardNo" value="<%=c.getBoardNo()%>"></th>
			      			<th class="hidden-col"><input type="hidden" name= "commentNo" value="<%=commentNo%>"></th>
			      			<%
			      				if(commentNo==c.getCommentNo()){
			      			%>
			      				<th><textarea rows="2" cols="45" name="commentContent"><%=c.getCommentContent()%></textarea></th>
			      			<%
			      				}else{
			      			%>
			      					<th><%=c.getCommentContent()%></th>
			      			<%
			      				}
			      			%>
			      			<th><%=c.getMemberId()%></th>
			      			<th><%=c.getCreatedate()%></th>
			      			<th><%=c.getUpdatedate()%></th>
			    		
			    		 <% //로그인한 아이디와 댓글글 작성자가 일치 할 때만 노출
					      	if(loginMemberId!=null){
					      		if(loginMemberId.equals((String)c.getMemberId())){
					     %>		      			
			      			<th><button type="submit" class="btn btn-outline-dark">저장</button></th>
			      			<th><a class="btn btn-outline-dark" href="<%=request.getContextPath()%>/board/removeCommentAction.jsp?boardNo=<%=c.getBoardNo()%>&commentNo=<%=c.getCommentNo()%>" role="button">삭제</a></th>
			      		</tr>			      		
		      	<%
					      		}
					      	}
		      			}	
	      			}
		      	%>
	      	</table>
	      	</form>
	   </div>
			
	   <!--3-5)comment 입력 :세션유무에 따른 분기  --> 
	   <%
	   		//로그인 사용자만 댓글입력 허용
	   		if(session.getAttribute("loginMemberId")!=null){
	   			// 현재 로그인 사용자의 아이디
	   			 loginMemberId = (String)session.getAttribute("loginMemberId");
	   %>
	   		<form action="<%=request.getContextPath()%>/board/insertCommentAction.jsp" method="post">
	   			<input type="hidden" name="boardNo" value="<%=bO.getBoardNo()%>">
	   			<input type="hidden" name="boardNo" value="<%=loginMemberId%>">
	   			<table>
	   				<tr>
	   					<th>댓글입력하기</th>
	   					<td>
	   						<textarea rows="2" cols="90" name="commentContent"></textarea>
	   					</td>
	   					<td>
	   						<button type="submit">댓글입력</button>
	   					</td>
	   				</tr>
	   			</table>
	   		</form>	
	   <%
	   		}
	   %>   
	   <div style="text-align:center;">
				<a href="<%=request.getContextPath()%>/board/boardOne2.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage-1%>">
					이전
				</a>
				<a href="<%=request.getContextPath()%>/board/boardOne2.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage+1%>">
					다음
				</a>
	   </div>		
		<footer class="ftco-footer ftco-bg-dark ftco-section">
      	<div>
			<!-- include 페이지 : Copyright &copy; 구디아카데미 -->
			<jsp:include page="/inc/copyright.jsp"></jsp:include>
		</div>
			  Copyright &copy;<script>document.write(new Date().getFullYear());</script> All rights reserved | This template is made with <i class="icon-heart" aria-hidden="true"></i> by <a href="https://colorlib.com" target="_blank">Colorlib</a>			     
   		</footer>
	
		</div><!-- END COLORLIB-MAIN -->
	</div><!-- END COLORLIB-PAGE -->	
</body>
</html>