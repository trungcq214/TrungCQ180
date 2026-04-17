package dao;

import dal.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import models.User;

public class UserDAO extends DBContext {

    public User login(String username, String password) {
        String sql = "SELECT * FROM [User] WHERE Username = ? AND Password = ? AND IsActive = 1";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, username);
            st.setString(2, password);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new User(
                    rs.getInt("UserId"),
                    rs.getString("Username"),
                    rs.getString("Email"),
                    rs.getString("Password"),
                    rs.getString("FullName"),
                    rs.getInt("Role"),
                    rs.getBoolean("IsActive"),
                    rs.getTimestamp("CreatedAt")
                );
            }
        } catch (SQLException e) {
            System.out.println("Login error: " + e.getMessage());
        }
        return null;
    }

    public List<User> getAllStaff() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM [User] WHERE Role = 1";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                list.add(new User(
                    rs.getInt("UserId"),
                    rs.getString("Username"),
                    rs.getString("Email"),
                    rs.getString("Password"),
                    rs.getString("FullName"),
                    rs.getInt("Role"),
                    rs.getBoolean("IsActive"),
                    rs.getTimestamp("CreatedAt")
                ));
            }
        } catch (SQLException e) {
            System.out.println("getAllStaff error: " + e.getMessage());
        }
        return list;
    }

    public User getUserByEmail(String email) {
        String sql = "SELECT * FROM [User] WHERE Email = ?";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, email);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new User(
                    rs.getInt("UserId"),
                    rs.getString("Username"),
                    rs.getString("Email"),
                    rs.getString("Password"),
                    rs.getString("FullName"),
                    rs.getInt("Role"),
                    rs.getBoolean("IsActive"),
                    rs.getTimestamp("CreatedAt")
                );
            }
        } catch (SQLException e) {
            System.out.println("getUserByEmail error: " + e.getMessage());
        }
        return null;
    }
    
    public boolean checkUsernameExists(String username) {
        String sql = "SELECT * FROM [User] WHERE Username = ?";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, username);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return true;
            }
        } catch (SQLException e) {
            System.out.println("checkUsernameExists error: " + e.getMessage());
        }
        return false;
    }

    public boolean registerCustomer(String username, String email, String password, String fullName) {
        String sql = "INSERT INTO [User] (Username, Email, Password, FullName, Role, IsActive) VALUES (?, ?, ?, ?, 0, 1)";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, username);
            st.setString(2, email);
            st.setString(3, password);
            st.setString(4, fullName);
            int rows = st.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("registerCustomer error: " + e.getMessage());
        }
        return false;
    }

    public String getPasswordByUsername(String username) {
        String sql = "SELECT Password FROM [User] WHERE Username = ?";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, username);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getString("Password");
            }
        } catch (SQLException e) {
            System.out.println("getPasswordByUsername error: " + e.getMessage());
        }
        return null;
    }

    public User getUserByUsernameAndEmail(String username, String email) {
        String sql = "SELECT * FROM [User] WHERE Username = ? AND Email = ?";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, username);
            st.setString(2, email);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new User(
                    rs.getInt("UserId"),
                    rs.getString("Username"),
                    rs.getString("Email"),
                    rs.getString("Password"),
                    rs.getString("FullName"),
                    rs.getInt("Role"),
                    rs.getBoolean("IsActive"),
                    rs.getTimestamp("CreatedAt")
                );
            }
        } catch (SQLException e) {
            System.out.println("getUserByUsernameAndEmail error: " + e.getMessage());
        }
        return null;
    }

    public boolean insertStaff(User user) {
        String sql = "INSERT INTO [User] (Username, Email, Password, FullName, Role, IsActive) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, user.getUsername());
            st.setString(2, user.getEmail());
            st.setString(3, user.getPassword());
            st.setString(4, user.getFullName());
            st.setInt(5, 1); // Role 1 = Staff
            st.setBoolean(6, user.isIsActive());
            int rows = st.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("insertStaff error: " + e.getMessage());
        }
        return false;
    }

    public boolean updateStaff(User user) {
        String sql = "UPDATE [User] SET Email = ?, Password = ?, FullName = ?, IsActive = ? WHERE UserId = ?";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, user.getEmail());
            st.setString(2, user.getPassword());
            st.setString(3, user.getFullName());
            st.setBoolean(4, user.isIsActive());
            st.setInt(5, user.getUserId());
            int rows = st.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("updateStaff error: " + e.getMessage());
        }
        return false;
    }

    public boolean updateProfile(User user) {
        String sql = "UPDATE [User] SET Email = ?, Password = ?, FullName = ? WHERE UserId = ?";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, user.getEmail());
            st.setString(2, user.getPassword());
            st.setString(3, user.getFullName());
            st.setInt(4, user.getUserId());
            int rows = st.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("updateProfile error: " + e.getMessage());
        }
        return false;
    }

    public boolean deleteStaff(int userId) {
        // Soft delete
        String sql = "UPDATE [User] SET IsActive = 0 WHERE UserId = ?";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, userId);
            int rows = st.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("deleteStaff error: " + e.getMessage());
        }
        return false;
    }
}
