package com.app;

import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.db.DBConnectionManager;

import oracle.jdbc.OracleTypes;
import oracle.sql.ARRAY;


/**
 * @author Sagar Chaudhari
 *	Servlet to handle all requests for student registration systems 
 */
@WebServlet("/app")
public class Application extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public Application() {
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 *      Handling requests for Display table records, to display TA details, to fetch prerequisites and to drop student
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String display = request.getParameter("display");
		if (display != null) {// Display records
			ResultSet rs = displayRecs(display);
			RequestDispatcher rd = request.getRequestDispatcher("display.jsp");
			request.setAttribute("result", rs);
			request.setAttribute("tableName", display);
			rd.include(request, response);
		} else if (request.getParameter("classId") != null) {// Get TA details
			String classId = request.getParameter("classId");
			getClassTa(classId, request, response);

		} else if (request.getParameter("departmentCode") != null) {// Get Prerequisites
			String deptCode = request.getParameter("departmentCode");
			int course = Integer.parseInt(request.getParameter("course"));
			getPrerequisites(deptCode, course, request, response);

		} else if (request.getParameter("bHashdropStudentForm") != null) { // Drop student from class
			String bNo = request.getParameter("bHashdropStudentForm");
			String classId = request.getParameter("classTasForm");
			dropStudent(bNo, classId, request, response);
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 *      Handling requests for Student enrollment and to delete student
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		if (request.getParameter("bHashstudentEnrollmentForm") != null) {// Student Enrollment
			String bNo = request.getParameter("bHashstudentEnrollmentForm");
			String classId = request.getParameter("classClassesForm");
			enrollStudent(bNo, classId, request, response);

		} else if (request.getParameter("bHashdeleteStudentForm") != null) { // Delete Student
			String bNo = request.getParameter("bHashdeleteStudentForm");
			deleteStudent(bNo, request, response);
		}
	}

	private ResultSet displayRecs(String name) {
		switch (name) {
		case "students":
			return displayStudents();

		case "tas":
			return displayTas();

		case "courses":
			return displayCourses();

		case "prerequisites":
			return displayPrerequisites();

		case "classes":
			return displayClasses();

		case "enrollments":
			return displayEnrollments();

		case "logs":
			return displayLogs();
		}
		return null;
	}

	/**
	 * @return
	 * Method to display Students table records
	 */
	private ResultSet displayStudents() {
		try {
			Connection conn = DBConnectionManager.getConnection();
			CallableStatement cs = conn.prepareCall("begin DBPROJECT.show_students(:1); end;");
			cs.registerOutParameter(1, OracleTypes.CURSOR);
			cs.execute();
			ResultSet rs = (ResultSet) cs.getObject(1);
			return rs;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * @return
	 * Method to display Tas table records
	 */
	private ResultSet displayTas() {
		try {
			Connection conn = DBConnectionManager.getConnection();
			CallableStatement cs = conn.prepareCall("begin DBPROJECT.show_tas(:1); end;");
			cs.registerOutParameter(1, OracleTypes.CURSOR);
			cs.execute();
			ResultSet rs = (ResultSet) cs.getObject(1);
			return rs;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * @return
	 * Method to display Courses table records
	 */
	private ResultSet displayCourses() {
		try {
			Connection conn = DBConnectionManager.getConnection();
			CallableStatement cs = conn.prepareCall("begin DBPROJECT.show_courses(:1); end;");
			cs.registerOutParameter(1, OracleTypes.CURSOR);
			cs.execute();
			ResultSet rs = (ResultSet) cs.getObject(1);
			return rs;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * @return
	 * 	Method to display Prerequisites table records
	 */
	private ResultSet displayPrerequisites() {
		try {
			Connection conn = DBConnectionManager.getConnection();
			CallableStatement cs = conn.prepareCall("begin DBPROJECT.show_prerequisites(:1); end;");
			cs.registerOutParameter(1, OracleTypes.CURSOR);
			cs.execute();
			ResultSet rs = (ResultSet) cs.getObject(1);
			return rs;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * @return
	 * Method to display classes table records
	 */
	private ResultSet displayClasses() {
		try {
			Connection conn = DBConnectionManager.getConnection();
			CallableStatement cs = conn.prepareCall("begin DBPROJECT.show_classes(:1); end;");
			cs.registerOutParameter(1, OracleTypes.CURSOR);
			cs.execute();
			ResultSet rs = (ResultSet) cs.getObject(1);
			return rs;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * @return
	 * Method to display Enrollments table records
	 */
	private ResultSet displayEnrollments() {
		try {
			Connection conn = DBConnectionManager.getConnection();
			CallableStatement cs = conn.prepareCall("begin DBPROJECT.show_enrollments(:1); end;");
			cs.registerOutParameter(1, OracleTypes.CURSOR);
			cs.execute();
			ResultSet rs = (ResultSet) cs.getObject(1);
			return rs;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * @return
	 * Method to display Logs table records
	 */
	private ResultSet displayLogs() {
		try {
			Connection conn = DBConnectionManager.getConnection();
			CallableStatement cs = conn.prepareCall("begin DBPROJECT.show_logs(:1); end;");
			cs.registerOutParameter(1, OracleTypes.CURSOR);
			cs.execute();
			ResultSet rs = (ResultSet) cs.getObject(1);
			return rs;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * @param classId
	 * @param request
	 * @param response
	 * 	To fetch the TA details of a class
	 */
	private void getClassTa(String classId, HttpServletRequest request, HttpServletResponse response) {
		try {
			Connection conn = DBConnectionManager.getConnection();
			CallableStatement cs = conn.prepareCall("begin DBPROJECT.class_ta(:1, :2, :3); end;");
			cs.setString(1, classId);
			cs.registerOutParameter(2, OracleTypes.CURSOR);
			cs.registerOutParameter(3, OracleTypes.NUMBER);
			cs.execute();
			int err = cs.getInt(3);
			ResultSet rs = null;
			if (err == 1)
				System.out.println("Error : The classid is invalid");
			else if (err == 2)
				System.out.println("Error : The class has no TA");
			else
				rs = (ResultSet) cs.getObject(2);
			RequestDispatcher rd = request.getRequestDispatcher("classTa.jsp");
			request.setAttribute("err", err);
			request.setAttribute("result", rs);
			rd.include(request, response);
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (ServletException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * @param deptCode
	 * @param course
	 * @param request
	 * @param response
	 * 
	 * 	To find out the direct and indirect prerequisites of a course
	 */
	private void getPrerequisites(String deptCode, int course, HttpServletRequest request, HttpServletResponse response) {
		try {
			Connection conn = DBConnectionManager.getConnection();
			CallableStatement cs = conn.prepareCall("begin DBPROJECT.get_prereq(:1, :2, :3, :4); end;");
			cs.setString(1, deptCode);
			cs.setInt(2, course);
			cs.registerOutParameter(3, java.sql.Types.ARRAY, "PREREQARRAY");
			cs.registerOutParameter(4, OracleTypes.NUMBER);
			cs.execute();
			String result[] = {};
			int err = cs.getInt(4);
			if (err != 0) {
				ARRAY rs = (ARRAY) cs.getObject(3);
				result = (String[]) rs.getArray();
			}
			RequestDispatcher rd = request.getRequestDispatcher("prerequisites.jsp");
			request.setAttribute("err", err);
			request.setAttribute("result", result);
			request.setAttribute("deptCode", deptCode);
			request.setAttribute("course", course);
			rd.include(request, response);
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (ServletException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * @param bNo
	 * @param classId
	 * @param request
	 * @param response
	 * 	To enroll the student into class
	 */
	private void enrollStudent(String bNo, String classId,  HttpServletRequest request, HttpServletResponse response) {
		try {
			Connection conn = DBConnectionManager.getConnection();
			CallableStatement cs = conn.prepareCall("begin DBPROJECT.enroll_student(:1, :2, :3); end;");
			cs.setString(1, bNo);
			cs.setString(2, classId);
			cs.registerOutParameter(3, OracleTypes.NUMBER);
			cs.execute();
			int err = cs.getInt(3);
			RequestDispatcher rd = request.getRequestDispatcher("result.jsp");
			request.setAttribute("enroll", err);
			request.setAttribute("bNo", bNo);
			request.setAttribute("classId", classId);
			rd.include(request, response);
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (ServletException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * @param bNo
	 * @param classId
	 * @param request
	 * @param response
	 * 	To remove student from class
	 */
	private void dropStudent(String bNo, String classId, HttpServletRequest request, HttpServletResponse response) {
		try {
			Connection conn = DBConnectionManager.getConnection();
			CallableStatement cs = conn.prepareCall("begin DBPROJECT.drop_student(:1, :2, :3); end;");
			cs.setString(1, bNo);
			cs.setString(2, classId);
			cs.registerOutParameter(3, OracleTypes.NUMBER);
			cs.execute();
			int err = cs.getInt(3);
			RequestDispatcher rd = request.getRequestDispatcher("result.jsp");
			request.setAttribute("dropSt", err);
			request.setAttribute("bNo", bNo);
			request.setAttribute("classId", classId);
			rd.include(request, response);
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (ServletException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * @param bNo
	 * @param request
	 * @param response
	 * To delete the student from registration system
	 */
	private void deleteStudent(String bNo,  HttpServletRequest request, HttpServletResponse response) {
		try {
			Connection conn = DBConnectionManager.getConnection();
			CallableStatement cs = conn.prepareCall("begin DBPROJECT.delete_student(:1, :2); end;");
			cs.setString(1, bNo);
			cs.registerOutParameter(2, OracleTypes.NUMBER);
			cs.execute();
			int err = cs.getInt(2);
			RequestDispatcher rd = request.getRequestDispatcher("result.jsp");
			request.setAttribute("deleteSt", err);
			request.setAttribute("bNo", bNo);
			rd.include(request, response);
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (ServletException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
