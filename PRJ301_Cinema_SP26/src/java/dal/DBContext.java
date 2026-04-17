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

    /**
     * Tự động đặt lại IDENTITY seed sau khi xóa dữ liệu.
     * Ví dụ: nếu còn bản ghi có ID cao nhất là 3, ID tiếp theo sẽ là 4.
     * Nếu bảng rỗng, ID sẽ bắt đầu lại từ 1.
     * @param tableName Tên bảng (ví dụ: "Movie", "Snack")
     * @param pkColumn  Tên cột primary key (ví dụ: "MovieId", "SnackId")
     */
    public void resetIdentity(String tableName, String pkColumn) {
        String sql = "DECLARE @maxId INT; " +
                     "SELECT @maxId = ISNULL(MAX(" + pkColumn + "), 0) FROM " + tableName + "; " +
                     "DBCC CHECKIDENT ('" + tableName + "', RESEED, @maxId);";
        try (Connection conn = getConnection();
             java.sql.Statement st = conn.createStatement()) {
            st.execute(sql);
        } catch (SQLException e) {
            System.out.println("resetIdentity error [" + tableName + "]: " + e.getMessage());
        }
    }
}
