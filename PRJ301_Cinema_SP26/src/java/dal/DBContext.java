package dal;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * DBContext - Quản lý kết nối SQL Server
 * Dùng cho tất cả DAO classes
 */
public class DBContext {
    private static final String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=CinemaDB;encrypt=true;trustServerCertificate=true";
    private static final String DB_USER = "sa";
    private static final String DB_PASSWORD = "123";

    static {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException ex) {
            throw new RuntimeException("SQL Server Driver not found", ex);
        }
    }

    /**
     * Lấy connection mới từ connection pool
     * Servlet sẽ quản lý transaction (setAutoCommit, commit, rollback)
     */
    public Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }
}
