while ($true) {
    # List of YouTube video URLs
    $video_list = @(
        "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
        "https://www.youtube.com/watch?v=3tmd-ClpJxA",
        "https://www.youtube.com/watch?v=J---aiyznGQ",
        "https://www.youtube.com/watch?v=8kZg_ALxEz0",
        "https://www.youtube.com/watch?v=gy1B3agGNxw",
        "https://www.youtube.com/watch?v=hHW1oY26kxQ",
        "https://www.youtube.com/watch?v=O2ulyJuvU3Q",
        "https://www.youtube.com/watch?v=0XpU0SY7d9Y"
    )

    # Play a random video
    Start-Process (Get-Random $video_list) -PassThru | Wait-Process
}