<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%!Connection connection = null;
	PreparedStatement pstmt1 = null;
	PreparedStatement pstmt2 = null;
	ResultSet rs= null;

	public void jspInit() {
		System.out.println("Bootstrapping the environment...");
		ServletConfig config = getServletConfig();
		String url = config.getInitParameter("dbUrl");
		String user = config.getInitParameter("user");
		String password = config.getInitParameter("password");
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			connection = DriverManager.getConnection(url, user, password);
			pstmt1 = connection.prepareStatement("INSERT INTO employees3(ename,eaddress,esalary)VALUES(?,?,?)");
			pstmt2 = connection.prepareStatement("SELECT eid, ename, eaddress, esalary FROM employees3");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException se) {
			se.printStackTrace();
		}

	}%>

<%
	String action = request.getParameter("s1");
	System.out.println(action);
    if(action.equalsIgnoreCase("register")){
    	//take the data and perform insert operation
    	String eName=request.getParameter("ename");
    	String eAddress=request.getParameter("eaddress");
    	String eSalary=request.getParameter("esalary");
    	if(pstmt1!=null){
    		pstmt1.setString(1, eName);
    		pstmt1.setString(2, eAddress);
    		pstmt1.setInt(3, Integer.parseInt(eSalary) );
    		
    		int rowCount=pstmt1.executeUpdate();
    		if(rowCount==1){
    			out.println("<h1 style='color:green; text-align:center'>Employee Successly Registered</h1>");
    		}else
    			out.println("<h1 style='color:red; text-align:center'>Employee Registration Failed</h1>");
    	}
    }else{
    	//get the data from the database using select operation
    	rs=pstmt2.executeQuery();
    	if(rs!=null){ %>
<table bgcolor='lightblue' align='center' border='1'>
	<tr>
		<th>EID</th>
		<th>ENAME</th>
		<th>EADDRESS</th>
		<th>ESALARY</th>
	</tr>
	<% while(rs.next()){ 
    			Integer id=rs.getInt(1);
    			String name=rs.getString(2);
    			String address=rs.getString(3);
    			Integer salary=rs.getInt(4); %>
	<tr>
		<td><%= id %></td>
		<td><%= name %></td>
		<td><%= address %></td>
		<td><%= salary %></td>
	</tr>
	<% }%>
</table>
<% }%>
<% }%>
<br />
<br />
<h1 style="text-align: center">
	<a href="./index.html">|HOMEPAGE|</a>
</h1>

<%!public void jspDestroy() {
	System.out.println("Cleaning the environment...");
		try {
			if (pstmt1 != null)
				pstmt1.close();
			if (pstmt2 != null)
				pstmt2.close();
		} catch (SQLException se) {
			se.printStackTrace();
		}
   }
%>
