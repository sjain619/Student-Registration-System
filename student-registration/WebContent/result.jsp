<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<%
		if(request.getAttribute("enroll")!=null){
			int err = (int) request.getAttribute("enroll");
			String bNo = (String) request.getAttribute("bNo");
			String classId = (String) request.getAttribute("classId");
			if(err == 1){ %>
				<h2>Error : The B#: <%= bNo %> is invalid.</h2>
		<%  }else if(err == 2)		
			{ %>
				<h2>Error : The classId: <%= classId %> is invalid.</h2>
			<%}
			else if(err == 3)		
			{ %>
				<h2>Error : Cannot enroll into a class from a previous semester.</h2>
			<%}
			else if(err == 4){ %>
				<h2>Error : The class is already full.</h2>
			<%}
			else if(err == 5){ %>
				<h2>Error : The student is already in the class.</h2>
		<%
			}
			else if(err == 6){ %>
			<h2>Warning : The student will be overloaded with the new enrollment.</h2>
			<h2>Also the Enrollment was successful.</h2>
		<%
			}
			else if(err == 7){ %>
			<h2>Error : Students cannot be enrolled in more than five classes in the same semester.</h2>
		<%
			}
			else if(err == 8){ %>
			<h2>Error : Prerequisites not satisfied.</h2>
		<%
			}
			else{ %>
			<h2>Enrollment was successful.</h2>
		<%
			}
		}
		else if(request.getAttribute("dropSt")!=null){
			int err = (int) request.getAttribute("dropSt"); 
			String bNo = (String) request.getAttribute("bNo");
			String classId = (String) request.getAttribute("classId");
			
			if(err == 1){ %>
				<h2>Error : The B#: <%= bNo %> is invalid.</h2>
		<%  }else if(err == 2)		
			{ %>
				<h2>Error : The classId: <%= classId %> is invalid.</h2>
			<%}
			else if(err == 3)		
			{ %>
				<h2>Error : The student is not enrolled in the class.</h2>
			<%}
			else if(err == 4){ %>
				<h2>Error : Only enrollment in the current semester can be dropped.</h2>
			<%}
			else if(err == 5){ %>
				<h2>Error : The drop is not permitted because another class the student registered uses it as a prerequisite.</h2>
		<%
			}
			else if(err == 6){ %>
			<h2>Student dropped successfully </h2>
			<h2>Note : This student is not enrolled in any classes.</h2>
		<%
			}
			else if(err == 7){ %>
			<h2>Student dropped successfully</h2>
			<h2>Note: The class now has no students.</h2>
		
		<% }
			else if(err == 8){ %>
			<h2>Student dropped successfully</h2>
			<h2>Note : This student is not enrolled in any classes.</h2>
			<h2>Note: The class now has no students.</h2>
		<%
			} 
			else{ %>
			<h2>Student dropped successfully</h2>
		<%
			} 
		
		}
	
		else if(request.getAttribute("deleteSt")!=null){
			int err = (int) request.getAttribute("deleteSt");
			String bNo = (String) request.getAttribute("bNo");
			
			if(err == 1){ %>
			<h2>Error : The B#: <%= bNo %> is invalid.</h2>
		<%  }
			else{ %>
			<h2>Student deleted successfully</h2>
		<%
			} 
		}
		%>
</body>
</html>