// StudentPage.bal
// package studentpage;

public class StudentPage {
    
    public function getHtml() returns string {
        return string ` 
            <!DOCTYPE html>
            <html>
            <head>
                <title>Student Dashboard</title>
                <style>
                    /* CSS styles for the student dashboard */
                    body {
                        font-family: 'Arial', sans-serif;
                        background-color: #f4f4f4;
                        text-align: center;
                        padding: 50px;
                    }
                </style>
            </head>
            <body>
                <h1>Welcome to the Student Dashboard</h1>
                <p>Here you can access all your courses and materials.</p>
            </body>
            </html>
        `;
    }
}
