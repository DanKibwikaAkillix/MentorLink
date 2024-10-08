import ballerina/http;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;
import ballerina/sql;

mysql:Client dbClient = check new (
    host = "localhost",
    port = 3306,
    user = "root",
    password = "",
    database = "mentorlink"
);

service / on new http:Listener(9080) {

    resource function get loginPage(http:Caller caller, http:Request req) returns error? {
        string htmlContent = getLoginPageHtml();
        
        http:Response res = new;
        res.setPayload(htmlContent);
        res.setHeader("Content-Type", "text/html");
        check caller->respond(res);
    }

    resource function post login(http:Caller caller, http:Request req) returns error? {
        // Create a response object
        http:Response res = new;

        var payload = req.getFormParams();
        if payload is error {
            res.setPayload("Error retrieving login details");
            res.setHeader("Content-Type", "text/plain");
            check caller->respond(res);
            return;
        }

        string? userId = payload.get("userID");
        string? password = payload.get("password"); // Assume you have a password input field

        sql:ParameterizedQuery query = `SELECT userType FROM users WHERE userID = ${userId} AND password = ${password}`;
        stream<record {| string userType; |}, sql:Error?> userResult = check dbClient->query(query);

        record {| record {| string userType; |} value; |}|sql:Error? userRecord = userResult.next();

        if userRecord is record {| record {| string userType; |} value; |} {
            string userType = userRecord.value.userType;

            match userType {
                "student" => {
                    StudentPage studentPage = new;
                    string studentHtml = studentPage.getHtml();
                    res.setPayload(studentHtml);
                }
                "lecturer" => {
                    // Construct the redirect URL with userID as a query parameter
                    string redirectUrl = "http://127.0.0.1:9081/subscribers/list?userID=" + <string>userId;
                    // Redirect lecturer to a different page
                    http:Response redirectRes = new;
                    redirectRes.statusCode = 302;
                    redirectRes.setHeader("Location", redirectUrl);
                    check caller->respond(redirectRes);
                    return; // Exit after redirect
                }
                _ => {
                    string errorHtml = getErrorPageHtml("Invalid user type.");
                    res.setPayload(errorHtml);
                }
            }
        } else if userRecord is () {
            // No user found
            string errorHtml = getErrorPageHtml("Invalid ID or password.");
            res.setPayload(errorHtml);
        } else {
            // Database error
            string errorHtml = getErrorPageHtml("Database error. Please try again later.");
            res.setPayload(errorHtml);
        }

        // Don't forget to close the stream
        check userResult.close();

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
                    position: relative;
                }
                form {
                    background-color: #ffffff;
                    padding: 30px;
                    border-radius: 12px;
                    box-shadow: 0px 10px 20px rgba(0, 0, 0, 0.1);
                    max-width: 500px;
                    width: 100%;
                    text-align: center;
                }
                h2 {
                    font-size: 24px;
                    color: #004a80;
                    margin-bottom: 20px;
                }
                label {
                    font-size: 16px;
                    color: #333333;
                    display: block;
                    margin-bottom: 8px;
                    text-align: left;
                }
                input[type="text"], input[type="password"], input[type="submit"] {
                    width: 80%;
                    padding: 12px;
                    margin-bottom: 15px;
                    border-radius: 8px;
                    border: 1px solid #ccc;
                    outline: none;
                    font-size: 16px;
                }
                input[type="text"]:focus, input[type="password"]:focus {
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
                .logo-container {
                    position: absolute;
                    right: 30px;
                    top: 20px;
                }
                .logo-container img {
                    max-width: 150px;
                    height: auto;
                }
                @media screen and (max-width: 600px) {
                    form {
                        padding: 15px;
                    }
                    .logo-container {
                        right: 10px;
                        top: 10px;
                    }
                    .logo-container img {
                        max-width: 100px;
                    }
                }
            </style>
        </head>
        <body>
            <form action="/login" method="post">
                <h2>Login</h2>
                <label for="userID">Enter your ID:</label><br>
                <input type="text" id="userID" name="userID" required><br>
                <label for="password">Password:</label><br>
                <input type="password" id="password" name="password" required><br>
                <input type="submit" value="Login">
            </form>
            <div class="logo-container">
                <img src="https://th.bing.com/th/id/R.1349357045f290f5e3053b50755b4bf0?rik=SGlYLoiUTN877Q&riu=http%3a%2f%2fwww.nche.org.na%2fsites%2fdefault%2ffiles%2finstitutions%2fnust_logo_received_sshikongo_0.jpg&ehk=6PKNxeyDX3SGn%2fTzxXWiaHp73BBhSUEh5TGu602QCYY%3d&risl=&pid=ImgRaw&r=0" alt="NUST Logo">
            </div>
        </body>
        </html>
    `;
}

function getErrorPageHtml(string errorMessage) returns string {
    return string ` 
        <!DOCTYPE html>
        <html>
        <head>
            <title>Login Failed</title>
            <style>
                body {
                    font-family: 'Arial', sans-serif;
                    background-color: #f4f4f4;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    height: 100vh;
                    margin: 0;
                    position: relative;
                }
                .error-container {
                    background-color: #fff;
                    padding: 20px;
                    border-radius: 12px;
                    box-shadow: 0px 10px 20px rgba(0, 0, 0, 0.1);
                    text-align: center;
                }
                h2 {
                    color: #d9534f;
                }
                p {
                    color: #333;
                }
                a {
                    color: #004a80;
                    text-decoration: underline;
                }
                .logo-container {
                    position: absolute;
                    right: 30px;
                    top: 20px;
                }
                .logo-container img {
                    max-width: 150px;
                    height: auto;
                }
                @media screen and (max-width: 600px) {
                    .error-container {
                        padding: 15px;
                    }
                    .logo-container {
                        right: 10px;
                        top: 10px;
                    }
                    .logo-container img {
                        max-width: 100px;
                    }
                }
            </style>
        </head>
        <body>
            <div class="error-container">
                <h2>Login Failed</h2>
                <p>${errorMessage}</p>
                <p><a href="http://127.0.0.1:9080/loginPage?">Please try again.</a></p>
            </div>
            <div class="logo-container">
                <img src="https://th.bing.com/th/id/R.1349357045f290f5e3053b50755b4bf0?rik=SGlYLoiUTN877Q&riu=http%3a%2f%2fwww.nche.org.na%2fsites%2fdefault%2ffiles%2finstitutions%2fnust_logo_received_sshikongo_0.jpg&ehk=6PKNxeyDX3SGn%2fTzxXWiaHp73BBhSUEh5TGu602QCYY%3d&risl=&pid=ImgRaw&r=0" alt="NUST Logo">
            </div>
        </body>
        </html>
    `;
}
