// LecturerPage.bal
// package lecturerpage;

public class LecturerPage {
    
    public function getHtml() returns string {
        return string ` 
            <!DOCTYPE html>
            <html lang="en">
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Lecturer Dashboard</title>
                <style>
                    /* CSS styles for the lecturer dashboard */
                    body {
                        font-family: 'Arial', sans-serif;
                        background-color: #e9ecef;
                        margin: 0;
                        padding: 0;
                        display: flex;
                        flex-direction: column;
                        min-height: 100vh;
                    }
                    .container {
                        max-width: 1200px;
                        margin: auto;
                        padding: 20px;
                        background-color: #ffffff;
                        border-radius: 10px;
                        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                        flex: 1;
                    }
                    header {
                        text-align: center;
                        padding: 20px 0;
                        background-color: #007bff;
                        color: white;
                        border-radius: 10px 10px 0 0;
                    }
                    h1 {
                        font-size: 2.5rem;
                        margin: 0;
                    }
                    .dashboard {
                        display: flex;
                        justify-content: space-between;
                        margin-top: 20px;
                        flex-wrap: wrap; /* Allows wrapping for smaller screens */
                    }
                    .card {
                        background-color: #f8f9fa;
                        border-radius: 10px;
                        padding: 20px;
                        flex: 1 1 calc(33.333% - 20px); /* Default: three cards in a row */
                        margin: 10px; /* Margin between cards */
                        text-align: center;
                        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
                        transition: transform 0.3s, box-shadow 0.3s;
                        cursor: pointer; /* Indicate the card is clickable */
                    }
                    .card:hover {
                        transform: translateY(-5px);
                        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
                    }
                    .card h2 {
                        color: #007bff;
                        font-size: 1.5rem;
                    }
                    .card p {
                        color: #555;
                        font-size: 1rem;
                    }
                    footer {
                        text-align: center;
                        margin-top: 20px;
                        color: #777;
                        padding: 10px 0;
                        background-color: #f8f9fa;
                        border-radius: 0 0 10px 10px;
                    }

                    /* Responsive styles */
                    @media (max-width: 768px) {
                        .dashboard {
                            flex-direction: column; /* Stack cards vertically */
                        }
                        .card {
                            flex: 1 1 100%; /* Full width on mobile */
                            margin: 10px 0; /* Margin between stacked cards */
                        }
                    }

                    /* Slider styles for mobile */
                    .slider {
                        display: none; /* Hidden by default */
                    }
                    @media (max-width: 768px) {
                        .slider {
                            display: block; /* Show slider on mobile */
                            position: relative;
                            overflow: hidden;
                        }
                        .slide {
                            display: none; /* Hide all slides */
                        }
                        .slide.active {
                            display: block; /* Show active slide */
                        }
                        .slide {
                            width: 100%;
                            height: 300px; /* Adjust height as necessary */
                            background-color: #007bff;
                            color: white;
                            border-radius: 10px;
                            padding: 20px;
                            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                        }
                    }
                </style>
                <script>
                    // JavaScript for slider functionality
                    let currentSlide = 0;
                    const slides = document.querySelectorAll('.slide');

                    function showSlide(index) {
                        slides.forEach((slide, i) => {
                            slide.classList.remove('active');
                            if (i === index) {
                                slide.classList.add('active');
                            }
                        });
                    }

                    function nextSlide() {
                        currentSlide = (currentSlide + 1) % slides.length;
                        showSlide(currentSlide);
                    }

                    function prevSlide() {
                        currentSlide = (currentSlide - 1 + slides.length) % slides.length;
                        showSlide(currentSlide);
                    }

                    document.addEventListener('DOMContentLoaded', () => {
                        showSlide(currentSlide);
                        setInterval(nextSlide, 3000); // Auto slide every 3 seconds
                    });
                </script>
            </head>
            <body>
                <header>
                    <h1>Welcome to the Lecturer Dashboard</h1>
                </header>
                <div class="container">
                    <div class="slider">
                        <div class="slide active" onclick="location.href='subscriberServices.html'">
                            <h2>Subscribers</h2>
                            <p>Manage your subscribers here.</p>
                        </div>
                        <div class="slide" onclick="location.href='#messages'">
                            <h2>Messages</h2>
                            <p>Check your messages and notifications.</p>
                        </div>
                        <div class="slide" onclick="location.href='#statistics'">
                            <h2>Statistics Performance Rating</h2>
                            <p>View your performance ratings here.</p>
                        </div>
                    </div>
                    <div class="dashboard">
                        <div class="card" onclick="location.href='http://localhost:9081/subscribers/list'">
                            <h2>Subscribers</h2>
                            <p>Manage your subscribers here.</p>
                        </div>
                        <div class="card" onclick="location.href='#messages'">
                            <h2>Messages</h2>
                            <p>Check your messages and notifications.</p>
                        </div>
                        <div class="card" onclick="location.href='#statistics'">
                            <h2>Statistics Performance Rating</h2>
                            <p>View your performance ratings here.</p>
                        </div>
                    </div>
                </div>
                <footer>
                    <p>&copy; 2024 Lecturer Dashboard</p>
                </footer>
            </body>
            </html>
        `;
    }
}
