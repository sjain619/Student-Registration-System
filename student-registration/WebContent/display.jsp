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
		String table = (String)request.getAttribute("tableName");
		ResultSet rs = (ResultSet)request.getAttribute("result");
		int cols = 0;
		if(table.equals("students"))
		{
			cols = 8;
		%>
			<TABLE BORDER="2" style="border-collapse: collapse; border-style: solid;">
            <TR>
               <TH>B#</TH>
               <TH>First_Name</TH>
               <TH>Last_Name</TH>
               <TH>Status</TH>
               <TH>GPA</TH>
               <TH>Email</TH>
               <TH>BDate</TH>
               <TH>DeptName</TH>
           </TR>
	  <%}else if(table.equals("tas")){
			cols = 3;
		%>
			<TABLE BORDER="1" style="border-collapse: collapse; border-style: solid;">
            <TR>
               <TH>B#</TH>
               <TH>TA_Level</TH>
               <TH>Office</TH>
           </TR>
		<%}else if(table.equals("courses")){
			cols = 3;
		%>
			<TABLE BORDER="1" style="border-collapse: collapse; border-style: solid;">
            <TR>
               <TH>Dept_Code</TH>
               <TH>Course#</TH>
               <TH>Title</TH>
           </TR>
		<%}else if(table.equals("prerequisites")){
			cols = 4;
		%>
			<TABLE BORDER="1" style="border-collapse: collapse; border-style: solid;">
            <TR>
               <TH>Dept_Code</TH>
               <TH>Course#</TH>
               <TH>Pre_Dept_Code</TH>
               <TH>Pre_Course#</TH>
           </TR>
		<%}else if(table.equals("classes")){
			cols = 10;
		%>
			<TABLE BORDER="1" style="border-collapse: collapse; border-style: solid;">
            <TR>
               <TH>ClassId</TH>
               <TH>Dept_Code</TH>
               <TH>Course#</TH>
               <TH>Sec#</TH>
               <TH>Year</TH>
               <TH>Semester</TH>
               <TH>Limit</TH>
               <TH>Class_Size</TH>
               <TH>Room</TH>
               <TH>TA_B#</TH>
           </TR>
		<%}else if(table.equals("enrollments")){
			cols = 3;
		%>
			<TABLE BORDER="1" style="border-collapse: collapse; border-style: solid;">
            <TR>
               <TH>B#</TH>
               <TH>ClassId</TH>
               <TH>LGrade</TH>
           </TR>
		<%}else if(table.equals("logs")){
			cols = 6;
		%>
			<TABLE BORDER="1" style="border-collapse: collapse; border-style: solid;">
            <TR>
               <TH>Log#</TH>
               <TH>OP_Name</TH>
               <TH>OP_Time#</TH>
               <TH>Table_Name</TH>
               <TH>Operation</TH>
               <TH>Key_Value</TH>
           </TR>
		<%}
		while(rs.next())
	    {
	        %>
	               <TR>
	              <% for(int i=1; i<=cols; i++){ %>
	                   <TD> <%= rs.getString(i) %><%}%> </TD>
	               </TR>
	                 <% 
	              
	    } 
	    %>
	           </TABLE>

</body>
</html>