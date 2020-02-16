<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<%
		int err = (int)request.getAttribute("err");
		ResultSet rs = (ResultSet)request.getAttribute("result");
		if(err == 1)
		{%> <h2>Error : The classid is invalid</h2> <%} 
		
		else if(err == 2){%>
			<h2>Error : The class has no TA</h2>
		<%} 
		else{
		%>
			<h1>TA details:</h1>
			<TABLE BORDER="1" style="border-collapse: collapse; border-style: solid;">
            <TR>
               <TH>B#</TH>
               <TH>First_Name</TH>
               <TH>Last_Name</TH>
           </TR>
           <%
           while(rs.next())
   	    	{
   	        %>
   	               <TR>
   	              <% for(int i=1; i<4; i++){ %>
   	                   <TD> <%= rs.getString(i) %><%}%> </TD>
   	               </TR>
   	                 <% 
   	    	} 
		}
           %>
           </TABLE>
</body>
</html>