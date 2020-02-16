<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@page import="oracle.sql.ARRAY"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<%
		int err = (int)request.getAttribute("err");
		String deptCode = (String)request.getAttribute("deptCode");
		int course = (int)request.getAttribute("course");
		String rs[] = (String[])request.getAttribute("result");
		if(err == 0)
		{%> <h2>Error : <%= deptCode %><%= course %> does not exist.</h2> <%} 
		else{
		%>
			<h1>Course <%= deptCode %><%= course %> Prerequisites :</h1>
			<TABLE BORDER="1" style="border-collapse: collapse; border-style: solid;">
            <TR>
               <TH>Course</TH>
           </TR>
           <%
          	for(int i=0; i<rs.length; i++)
   	    	{
   	        %>
   	               <TR>
   	                   <TD> <%= rs[i] %> </TD>
   	               </TR>
   	                 <% 
   	    	} 
		}
           %>
           </TABLE>
</body>
</html>