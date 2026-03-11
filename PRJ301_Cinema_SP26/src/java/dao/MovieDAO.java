package dao;

import dal.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import models.Movie;

public class MovieDAO extends DBContext {

    public List<Movie> getAllMovies() {
        List<Movie> list = new ArrayList<>();
        String sql = "SELECT * FROM Movie";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                list.add(new Movie(
                    rs.getInt("MovieId"),
                    rs.getString("Title"),
                    rs.getString("Description"),
                    rs.getInt("Duration"),
                    rs.getDate("ReleaseDate"),
                    rs.getString("PosterUrl")
                ));
            }
        } catch (SQLException e) {
            System.out.println("getAllMovies error: " + e.getMessage());
        }
        return list;
    }

    public Movie getMovieById(int movieId) {
        String sql = "SELECT * FROM Movie WHERE MovieId = ?";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, movieId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return new Movie(
                        rs.getInt("MovieId"),
                        rs.getString("Title"),
                        rs.getString("Description"),
                        rs.getInt("Duration"),
                        rs.getDate("ReleaseDate"),
                        rs.getString("PosterUrl")
                    );
                }
            }
        } catch (SQLException e) {
            System.out.println("getMovieById error: " + e.getMessage());
        }
        return null;
    }

    public boolean insertMovie(Movie movie) {
        String sql = "INSERT INTO Movie (Title, Description, Duration, ReleaseDate, PosterUrl) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, movie.getTitle());
            st.setString(2, movie.getDescription());
            st.setInt(3, movie.getDuration());
            st.setDate(4, movie.getReleaseDate());
            st.setString(5, movie.getPosterUrl());
            int rows = st.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("insertMovie error: " + e.getMessage());
        }
        return false;
    }

    public boolean updateMovie(Movie movie) {
        String sql = "UPDATE Movie SET Title = ?, Description = ?, Duration = ?, ReleaseDate = ?, PosterUrl = ? WHERE MovieId = ?";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, movie.getTitle());
            st.setString(2, movie.getDescription());
            st.setInt(3, movie.getDuration());
            st.setDate(4, movie.getReleaseDate());
            st.setString(5, movie.getPosterUrl());
            st.setInt(6, movie.getMovieId());
            int rows = st.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("updateMovie error: " + e.getMessage());
        }
        return false;
    }

    public boolean deleteMovie(int movieId) {
        String sql = "DELETE FROM Movie WHERE MovieId = ?";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, movieId);
            int rows = st.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("deleteMovie error: " + e.getMessage());
        }
        return false;
    }
}
