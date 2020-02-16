package com.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * @author sagar chaudhari
 *	Class for managing database connection
 */
public class DBConnectionManager {

	private static Connection connection;
	
	public static Connection getConnection(){
		if (connection == null) {
			try {
				Class.forName("oracle.jdbc.driver.OracleDriver");
				connection = DriverManager.getConnection("jdbc:oracle:thin:@castor.cc.binghamton.edu:1521:acad111",
						"schaud16", "Sagar1004");
			} catch (SQLException | ClassNotFoundException e) {
				e.printStackTrace();
			}
			return connection;
		}
		else 
			return connection;
	}
}
