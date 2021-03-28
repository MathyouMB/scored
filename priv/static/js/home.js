(() => {
    class RequestHandler {
        createRoom() {
            fetch('http://localhost:4000/api/create', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
            })
            .then(response => response.json())
            .then(data => {
                window.location.replace('http://localhost:4000/' + data.room_id + '?owner=true');
            })
            .catch((error) => {
                console.error('Error:', error);
            });
        }
    }

    const requestHandler = new RequestHandler()
    document.getElementById("nav")
      .addEventListener("click", () => requestHandler.createRoom())  
})()
