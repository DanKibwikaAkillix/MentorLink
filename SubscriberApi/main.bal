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

// Define a Student record
type Student record {
    string name;
    string studentNumber; // 12-digit student number
};

// Create a new HTTP service
service /subscribers on new http:Listener(9081) {

    // Define the endpoint to get the list of subscribers
    resource function get list(http:Caller caller, http:Request req) returns error? {
        string? userID = req.getQueryParamValue("userID");
        
        if (userID is string) {
            string|error html = getSubscribersList(userID);
            
            http:Response response = new;
            response.setPayload(check html);
            response.setHeader("Content-Type", "text/html");
            check caller->respond(response);
        } else {
            http:Response response = new;
            response.setPayload("User ID is required.");
            check caller->respond(response);
        }
    }
}

// Function to retrieve the list of subscribers from the database
function getSubscribersList(string userID) returns string|error {
    sql:ParameterizedQuery query = `SELECT Student_Name, Student_Number FROM subscribers WHERE Student_Mentor_ID = ${userID}`;
    stream<record {|anydata...;|}, sql:Error?> resultStream = dbClient->query(query);
    string html = createHTMLHeader();

    error? e = resultStream.forEach(function(record {} row) {
        Student student = {
            name: row["Student_Name"].toString(),
            studentNumber: row["Student_Number"].toString()
        };
        html += createStudentRow(student);
    });

    if e is error {
        return error("Error while processing result stream", e);
    }

    if html.endsWith(createHTMLHeader()) {
        html += "<tr><td colspan='3' class='text-center'>No subscribers found.</td></tr>";
    }

    html += createHTMLFooter();
    return html;
}

// Function to create HTML header
function createHTMLHeader() returns string {
    return "<!DOCTYPE html>" +
           "<html lang='en'>" +
           "<head>" +
           "<meta charset='UTF-8'>" +
           "<meta name='viewport' content='width=device-width, initial-scale=1.0'>" +
           "<title>Subscribers List</title>" +
           "<link href='https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css' rel='stylesheet'>" +
           "<style>" +
           "body { font-family: 'Roboto', sans-serif; background: url('https://th.bing.com/th/id/R.f93fea6320bdd05a4055c19c084e3aca?rik=aykuZS12fOMYbg&pid=ImgRaw&r=0') no-repeat center center fixed; background-size: cover; margin: 0; padding: 0; }" +
           ".container { width: 90%; max-width: 800px; margin: 20px auto; padding: 20px; background: rgba(255, 255, 255, 0.8); border-radius: 8px; box-shadow: 0 0 15px rgba(0, 0, 0, 0.1); }" +
           ".header { text-align: center; margin-bottom: 20px; }" +
           ".header h1 { color: #007bff; }" +
           "</style>" +
           "</head>" +
           "<body>" +
           "<div class='container'>" +
           "<div class='header'>" +
           "<h1>Subscribers</h1>" + 
           "</div>" +
           "<div class='table-responsive'>" +
           "<table class='table table-bordered'>" +
           "<thead class='thead-light'>" +
           "<tr>" +
           "<th>Name</th>" +
           "<th>Student Number</th>" +
           "<th>Action</th>" + 
           "</tr>" +
           "</thead>" +
           "<tbody>";
}

// Function to create a row for each student in the table
function createStudentRow(Student student) returns string {
    return "<tr>" +
           "<td>" + student.name + "</td>" +
           "<td>" + student.studentNumber + "</td>" +
           "<td><button class='btn btn-primary' onclick=\"showModal('" + student.name + "')\">Read Messages</button></td>" + 
           "</tr>";
}

// Function to create HTML footer
function createHTMLFooter() returns string {
    return "</tbody></table></div></div>" + generateModalHtml() + "</body></html>";
}

// Function to generate the modal HTML with chat interface
function generateModalHtml() returns string {
    return "<!-- Modal Structure -->" +
           "<div id='chatModal' class='modal'>" +
           "<div id='modalContent' class='modal-content'>" +
           "<span onclick='closeModal()' style='float:right; cursor:pointer;'>&times;</span>" +
           "<h2 id='modalTitle'></h2>" +
           "<div class='chat-box'>" +
           "<div class='messages-section' id='messages'>" +
           "</div>" +
           "<div class='input-section'>" +
           "   <textarea id='messageInput' placeholder='Type your message here...'></textarea>" +
           "   <button id='sendMessageButton' onclick='sendMessage()'>" +
           "       <img src='https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSnoHHXzjyOsUzw1cRStAySKLB1GQKM5AeBOA&s' alt='Send' class='send-button' />" +
           "   </button>" +
           "</div></div></div></div>" +
           generateModalScript() + generateModalStyles();
}

// Function to generate modal-related JavaScript
function generateModalScript() returns string {
    return "<script>" +
           "function showModal(studentName) {" +
           "   var modal = document.getElementById('chatModal');" +
           "   modal.style.display = 'block';" +
           "   document.getElementById('modalTitle').innerText = 'Chat with ' + studentName;" +
           "}" +
           "function closeModal() {" +
           "   var modal = document.getElementById('chatModal');" +
           "   modal.style.display = 'none';" +
           "}" +
           "function sendMessage() {" +
           "   var inputField = document.getElementById('messageInput');" +
           "   var message = inputField.value;" +
           "   if (message.trim() === '') return;" +
           "   var messagesSection = document.getElementById('messages');" +
           "   messagesSection.innerHTML += '<div>' + message + '</div>';" +
           "   inputField.value = '';" +
           "   messagesSection.scrollTop = messagesSection.scrollHeight;" +
           "}" +
           "</script>";
}

// Function to generate modal-related CSS styles
function generateModalStyles() returns string {
    return "<style>" +
           ".modal { display: none; position: fixed; z-index: 1; left: 0; top: 0; width: 100%; height: 100%; overflow: auto; background-color: rgba(0, 0, 0, 0.7); }" +
           ".modal-content { width: 90%; max-width: 500px; margin: auto; background-color: transparent; border: none; position: relative; border-radius: 10px; padding: 0; }" +
           ".chat-box { display: flex; flex-direction: column; height: 500px; background-image: url('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSJOTkt4IS8NRopwKJFhuRVgdiDyJHupIVlLg&s'); background-size: cover; border-radius: 10px; padding: 10px; }" +
           ".messages-section { flex-grow: 1; overflow-y: auto; padding: 10px; border-radius: 8px; background: rgba(255, 255, 255, 0.9); }" +
           ".input-section { display: flex; align-items: center; margin-top: 10px; }" +
           ".input-section textarea { flex-grow: 1; padding: 10px; border-radius: 5px; border: 1px solid #ccc; margin-right: 10px; }" +
           ".send-button { width: 40px; height: 40px; background: none; border: none; cursor: pointer; }" +
           ".send-button:hover { transform: scale(1.1); }" +
           "</style>";
}
