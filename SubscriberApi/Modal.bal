public class Modal {
    // To hold the messages in memory
    private map<string> messages = {};

    // Constructor
    public function init() {
    }

    // Function to generate the modal HTML with the chat interface
    public function generateModalHtml() returns string {
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
               "   <div class='chat-controls'>" +
               "       <button id='emojiButton'>😊</button>" + // emoji support
               "       <label for='fileUpload' class='file-button'>📎</label>" +
               "       <input type='file' id='fileUpload' style='display:none;'/>" +
               "       <button id='sendMessageButton'>Send</button>" +
               "   </div>" +
               "</div></div></div></div>" +
               self.generateModalStyles() +  // Use self to reference class methods
               self.generateModalScript();   // Use self to reference class methods
    }

    // Function to generate the modal-related JavaScript
    public function generateModalScript() returns string {
        return "<script>" +
               "var messages = [];" +  // Array to hold messages in memory
               "function showModal(studentName) {" +
               "   var modal = document.getElementById('chatModal');" +
               "   var modalContent = document.getElementById('modalContent');" +
               "   modal.style.display = 'block';" +
               "   setTimeout(function() {" +
               "       modalContent.classList.add('show');" +
               "   }, 10);" +
               "   document.getElementById('modalTitle').innerText = 'Chat with ' + studentName;" +
               "}" +
               "function closeModal() {" +
               "   var modal = document.getElementById('chatModal');" +
               "   var modalContent = document.getElementById('modalContent');" +
               "   modalContent.classList.remove('show');" +
               "   setTimeout(function() {" +
               "       modal.style.display = 'none';" +
               "   }, 300);" +
               "}" +
               "// Function to display message with timestamp" +
               "function displayMessage(sender, message, timestamp) {" +
               "   var messagesDiv = document.getElementById('messages');" +
               "   var formattedMessage = '<div class=\"message ' + sender + '\">' + sender + ': ' + message + '<span class=\"timestamp\">' + timestamp + '</span></div>';" +
               "   messagesDiv.innerHTML += formattedMessage;" +
               "   messagesDiv.scrollTop = messagesDiv.scrollHeight;" + // Auto-scroll to the latest message
               "}" +
               "// Function to handle file uploads" +
               "document.getElementById('fileUpload').addEventListener('change', function(event) {" +
               "   var file = event.target.files[0];" +
               "   if (file) {" +
               "       var reader = new FileReader();" +
               "       reader.onload = function(e) {" +
               "           var timestamp = new Date().toLocaleTimeString([], {hour: '2-digit', minute: '2-digit'});" +
               "           displayMessage('Student', '<a href=\"' + e.target.result + '\" target=\"_blank\">' + file.name + '</a>', timestamp);" +
               "       };" +
               "       reader.readAsDataURL(file);" +
               "   }" +
               "});" +
               "// Send button event listener" +
               "document.getElementById('sendMessageButton').addEventListener('click', function() {" +
               "   var message = document.getElementById('messageInput').value;" +
               "   if (message.trim() !== '') {" +
               "       var timestamp = new Date().toLocaleTimeString([], {hour: '2-digit', minute: '2-digit'});" +
               "       displayMessage('Student', message, timestamp);" +
               "       messages.push({sender: 'Student', message: message, timestamp: timestamp});" + // Store message in memory
               "       document.getElementById('messageInput').value = '';" +
               "       // Simulate mentor reply after 1 second" +
               "       setTimeout(function() {" +
               "           displayMessage('Mentor', 'Thanks for your message!', timestamp);" +
               "           messages.push({sender: 'Mentor', message: 'Thanks for your message!', timestamp: timestamp});" + // Store mentor message
               "       }, 1000);" +
               "   }" +
               "});" +
               // Emoji picker initialization (use a library like EmojiMart for real implementation)
               "document.getElementById('emojiButton').addEventListener('click', function() {" +
               "   // Trigger emoji picker here" +
               "   alert('Emoji picker will open here');" +
               "});" +
               "</script>";
    }

    // Function to generate the modal-related CSS styles
    public function generateModalStyles() returns string {
        return "<style>" +
               "/* Modal Styles */" +
               ".modal { display: none; position: fixed; z-index: 1; left: 0; top: 0; width: 100%; height: 100%; overflow: auto; background-color: rgba(0,0,0,0.4); }" +
               ".modal-content { width: 80%; max-width: 600px; margin: auto; background-color: #fff; border-radius: 10px; padding: 20px; position: relative; }" +
               "/* Chat Box Styles */" +
               ".chat-box { display: flex; flex-direction: column; height: 400px; }" +
               ".messages-section { flex-grow: 1; overflow-y: auto; padding: 10px; border: 1px solid #ddd; margin-bottom: 10px; background-color: #f9f9f9; border-radius: 8px; }" +
               ".message { padding: 10px; border-radius: 5px; margin-bottom: 10px; }" +
               ".message.mentor { background-color: #007bff; color: white; align-self: flex-start; }" +
               ".message.student { background-color: #e2e2e2; color: black; align-self: flex-end; }" +
               ".timestamp { display: block; font-size: 12px; color: #888; margin-top: 5px; }" + // Timestamp style
               "/* Input Section Styles */" +
               ".input-section { display: flex; align-items: center; }" +
               "textarea { flex-grow: 1; padding: 10px; border-radius: 5px; border: 1px solid #ddd; resize: none; }" +
               ".chat-controls { display: flex; align-items: center; }" +
               "#emojiButton, #sendMessageButton, .file-button { background-color: #007bff; color: white; border: none; padding: 10px; margin-left: 10px; border-radius: 5px; cursor: pointer; }" +
               "#emojiButton:hover, #sendMessageButton:hover, .file-button:hover { background-color: #0056b3; }" +
               "</style>";
    }
}
