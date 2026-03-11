package models;

import java.sql.Date;

public class Movie {
    private int movieId;
    private String title;
    private String description;
    private int duration;
    private Date releaseDate;
    private String posterUrl;

    public Movie() {
    }

    public Movie(int movieId, String title, String description, int duration, Date releaseDate, String posterUrl) {
        this.movieId = movieId;
        this.title = title;
        this.description = description;
        this.duration = duration;
        this.releaseDate = releaseDate;
        this.posterUrl = posterUrl;
    }

    public int getMovieId() { return movieId; }
    public void setMovieId(int movieId) { this.movieId = movieId; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public int getDuration() { return duration; }
    public void setDuration(int duration) { this.duration = duration; }
    public Date getReleaseDate() { return releaseDate; }
    public void setReleaseDate(Date releaseDate) { this.releaseDate = releaseDate; }
    public String getPosterUrl() { return posterUrl; }
    public void setPosterUrl(String posterUrl) { this.posterUrl = posterUrl; }
}
