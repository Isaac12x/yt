
// Adds buttons -
document.addEventListener('DOMContentLoaded', function() {
    alert('yay')
    if (window.location.href.includes('/watch')) {
        // Create a div to hold the buttons
        var buttonsDiv = document.createElement('div');
        buttonsDiv.style.position = 'fixed';
        buttonsDiv.style.top = '0';
        buttonsDiv.style.left = '0';
        buttonsDiv.style.width = '100%';
        buttonsDiv.style.display = 'flex';
        buttonsDiv.style.justifyContent = 'center';
        buttonsDiv.style.zIndex = '1000'; // Ensure it's on top
        buttonsDiv.style.backgroundColor = 'white'; // Change as needed
        
        // Create Previous, Replay, and Next buttons
        var previousButton = createButton('⏮️');
        var replayButton = createButton('🔁');
        var nextButton = createButton('⏭️');
        
        // Append buttons to the div
        buttonsDiv.appendChild(previousButton);
        buttonsDiv.appendChild(replayButton);
        buttonsDiv.appendChild(nextButton);
        
        // Append the div to the body
        document.body.appendChild(buttonsDiv);
        
        // Function to create a button
        function createButton(icon) {
            var button = document.createElement('button');
            button.innerHTML = icon;
            button.style.margin = '10px';
            button.style.fontSize = '20px';
            button.style.width = '33%';
            button.onclick = function() {
                handleButtonClick(action);
            };
            return button;
        }
        
        var replayEnabled = false;
        
        // Function to check if the video has ended and replay it
        function checkAndReplayVideo() {
            if (replayEnabled) {
                var videoPlayer = document.querySelector('.html5-main-video');
                
                if (videoPlayer) {
                    // Check if the video has ended
                    if (videoPlayer.ended) {
                        // Replay the video
                        videoPlayer.play();
                    }
                }
            }
        }
        
        function handleButtonClick(action) {
            switch (action) {
                case 'previous':
                    // Handle navigating to previous URL
                    // Replace the alert with your logic
                    window.history.back();
                    break;
                case 'replay':
                    // Handle playing the video on repeat
                    // Replace the alert with your logic
                    replayEnabled = !replayEnabled;
                    break;
                case 'next':
                    // Handle going to next URL
                    // Replace the alert with your logic
                    window.history.forward() // or get next
                    break;
                default:
                    break;
            }
        }
        
        alert('Im loaded')
        
        
        var touchstartX = 0;
        var touchendX = 0;
        function handleGesture() {
            if (touchendX < touchstartX) {
                // Swiped left, go to the next URL
                if (window.location.href.includes('/shorts/')) {
                    // If the URL contains '/shorts/', navigate to a specific URL
                    window.location.href = 'https://m.youtube.com'; // Replace with your desired URL
                } else {
                    window.history.forward();
                }
            }
            if (touchendX > touchstartX) {
                // Swiped right, go to the previous URL
                window.history.back();
            }
        }
        
        document.addEventListener('touchstart', function(event) {
            touchstartX = event.changedTouches[0].screenX;
        }, false);
        
        document.addEventListener('touchend', function(event) {
            touchendX = event.changedTouches[0].screenX;
            handleGesture();
        }, false);
    }
    
});


