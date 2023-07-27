<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "java.util.*" %>
<%
	String driver="org.mariadb.jdbc.Driver";
	String dburl="jdbc:mariadb://3.38.38.146/userboard";
	String dbuser="root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement stmt = null ;
	ResultSet rs = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	//"SELECT local_name localName, '대한민국' country, '박성환' worker FROM local LIMT 0,1;";
	String sql = "SELECT local_name localName, '대한민국' country, '박성환' worker FROM local LIMIT 0,1";
	stmt = conn.prepareStatement(sql);
	
	System.out.println(stmt+"<--loginListByMap stmt");
	rs =stmt.executeQuery();
	//vo대신 HashMap 타입을 사용
	
	HashMap<String, Object> map = null;
	if(rs.next()){
		//디버깅
		System.out.println(rs.getString("localName"));
		System.out.println(rs.getString("country"));
		System.out.println(rs.getString("worker"));
		
		map = new HashMap<String, Object>();
		map.put("localName",rs.getString("localName"));
		map.put("country",rs.getString("country"));
		map.put("worker",rs.getString("worker"));
	
	}
	
	PreparedStatement stmt2 = null ;
	ResultSet rs2 = null;
	String sql2 = "SELECT local_name localName, '대한민국' country, '박성환' worker FROM local";
	stmt2 = conn.prepareStatement(sql2);
	
	
	
	 
	System.out.println(stmt2+"<--loginListByMap stmt2");
	rs2 =stmt2.executeQuery();
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while(rs2.next()){
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("localName",rs.getString("localName"));
		m.put("country",rs.getString("country"));
		m.put("worker",rs.getString("worker"));
		list.add(m);
	}
	
	PreparedStatement stmt3 = null ;
	ResultSet rs3 = null;
	String sql3 = "SELECT local_name localName, COUNT(local_name) cnt FROM board GROUP BY local_name";
	stmt3 = conn.prepareStatement(sql3);
	
	System.out.println(stmt3+"<--loginListByMap stmt3");
	rs3 =stmt3.executeQuery();
	ArrayList<HashMap<String, Object>> list3 = new ArrayList<HashMap<String, Object>>();
	while(rs3.next()){
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("localName",rs3.getString("localName"));
		m.put("cnt",rs3.getInt("cnt"));
		list3.add(m);
	}

	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div>
		<h2>rs1 결과셋</h2>
		<%=map.get("localName")%>
		<%=map.get("country")%>
		<%=map.get("worker")%>
	</div>
	
	<hr>
	<h2>rs2 결과셋</h2>
	<table>
		<tr>
			<th>localName</th>
			<th>country</th>
			<th>worker</th>
		</tr>
		<%
		 	for(HashMap<String, Object> m : list){
		%>
			<tr>
				<td><%=m.get("localName")%></td>
				<td><%=m.get("country")%></td>
				<td><%=m.get("worker")%></td>
			</tr>
		<% 
			}
		%>
	</table>
	
	<hr>
	<h2>rs3 결과셋</h2>
	<ul>
		<%
			for(HashMap<String, Object> m : list3) {
		%>
				<li>
					<a href="">
						<%=(String)m.get("localName")%>(<%=(Integer)m.get("cnt")%>)
					</a>
				</li>
		<%		
			}
		%>
	</ul>
</body>
</html>