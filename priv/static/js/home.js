(() => {
    class RequestHandler {
        createRoom() {
            fetch('http' + getEnv() + '://' + getDomain() + '/api/create', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
            })
            .then(response => response.json())
            .then(data => {
                window.location.replace('http' + getEnv() + '://' + getDomain() + '/' + data.room_id + '?owner=true');
            })
            .catch((error) => {
                console.error('Error:', error);
            });
        }
    }

    const getDomain = () => {
        let domain = (new URL(window.location.href))
        
        if (domain.hostname === 'localhost') {
            return domain.hostname + ':4000' 
        }

        return domain.hostname
    }

    const getEnv = () => {
        let domain = (new URL(window.location.href))
        
        if (domain.hostname === 'localhost') {
            return ''
        }
  
        return 's'
      }

    const requestHandler = new RequestHandler()
    document.getElementById("nav")
      .addEventListener("click", () => requestHandler.createRoom())  
})()
