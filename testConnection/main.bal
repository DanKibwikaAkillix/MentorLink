import ballerina/http;
import ballerina/sql;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;

// The `Album` record to load records from the `albums` table.
type Album record {| 
    string id; 
    string title; 
    string artist; 
    float price; 
|};

service / on new http:Listener(4040) {
    // The MySQL client instance to connect to the database.
    private final mysql:Client db;

    // Initialize the MySQL client in the service constructor.
    function init() returns error? {
        self.db = check new (
            host = "localhost",
            port = 3306,
            user = "root",
            password = "",
            database = "MUSIC_STORE"
        );
    }


service / on new http:Listener(9080) {


    // The MySQL client instance to connect to the database.
    private final mysql:Client db;

    // Initialize the MySQL client in the service constructor.
    function init() returns error? {
        self.db = check new (
            host = "http://127.0.0.1:8080/phpmyadmin",
            port = 3306,
            user = "root",
            password = "",
            database = "mentorlink"
        );
    }

    resource function get loginPage(http:Caller caller, http:Request req) returns error? {
        string htmlContent = getLoginPageHtml();
        
        http:Response res = new;
        res.setPayload(htmlContent);
        res.setHeader("Content-Type", "text/html");
        check caller->respond(res);
    }

    resource function post login(http:Caller caller, http:Request req) returns error? {
        var payload = req.getFormParams();
        if payload is error {
            check caller->respond("Error retrieving login details");
            return;
        }

        string? userId = payload.get("userID");

        http:Response res = new;
        if userId is string {
            if userId.startsWith("22") && userId.length() == 12 {
                // Create an instance of StudentPage and get the HTML
                StudentPage studentPage = new();
                string studentHtml = studentPage.getHtml();
                res.setPayload(studentHtml);
            } else if userId.startsWith("11") && userId.length() == 12 {
                // Create an instance of LecturerPage and get the HTML
                LecturerPage lecturerPage = new();
                string lecturerHtml = lecturerPage.getHtml();
                res.setPayload(lecturerHtml);
            } else {
                string errorHtml = getErrorPageHtml();
                res.setPayload(errorHtml);
            }
        } else {
            string errorHtml = getErrorPageHtml();
            res.setPayload(errorHtml);
        }

        res.setHeader("Content-Type", "text/html");
        check caller->respond(res);
    }
}

function getLoginPageHtml() returns string {
    return string ` 
        <!DOCTYPE html>
        <html>
        <head>
            <title>Login Page</title>
            <style>
                /* CSS styles for the form */
                body {
                    font-family: 'Arial', sans-serif;
                    background-color: #f4f4f4;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    height: 100vh;
                    margin: 0;
                }
                form {
                    background-color: #ffffff;
                    padding: 20px;
                    border-radius: 12px;
                    box-shadow: 0px 10px 20px rgba(0, 0, 0, 0.1);
                    max-width: 400px;
                    width: 100%;
                    text-align: center;
                }
                h2 {
                    font-size: 24px;
                    color: #004a80; /* NUST blue color */
                    margin-bottom: 20px;
                }
                label {
                    font-size: 16px;
                    color: #333333;
                    display: block;
                    margin-bottom: 8px;
                    text-align: left;
                }
                input[type="text"], input[type="submit"] {
                    width: 100%;
                    padding: 12px;
                    margin-bottom: 15px;
                    border-radius: 8px;
                    border: 1px solid #ccc;
                    outline: none;
                    font-size: 16px;
                }
                input[type="text"]:focus {
                    border-color: #004a80;
                    box-shadow: 0 0 5px rgba(0, 74, 128, 0.3);
                }
                input[type="submit"] {
                    background-color: #004a80;
                    color: #fff;
                    border: none;
                    cursor: pointer;
                    transition: background-color 0.3s ease;
                }
                input[type="submit"]:hover {
                    background-color: #003a63;
                }
                @media screen and (max-width: 600px) {
                    form {
                        padding: 15px;
                    }
                }
            </style>
        </head>
        <body>
            <form action="/login" method="post">
                <h2>Login</h2>
                <label for="userID">Enter your ID:</label><br>
                <input type="text" id="userID" name="userID" required><br><br>
                <input type="submit" value="Login">
            </form>
        </body>
        </html>
    `;
}

function getErrorPageHtml() returns string {
    return string `
        <!DOCTYPE html>
        <html>
        <head>
            <title>Login Failed</title>
        </head>
        <body>
            <h2>Login Failed</h2>
            <p>Invalid ID. Please try again.</p>
        </body>
        </html>
    `;
}
