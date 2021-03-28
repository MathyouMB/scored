(() => {
    class RequestHandler {
      revealVotes() {
        if (isOwner() == true) {
          fetch('http://localhost:4000/api/reveal/' + getRoomId(), {
              method: 'PUT',
              headers: {
                  'Content-Type': 'application/json',
              },
          })
          .catch((error) => {
              console.error('Error:', error);
          });
        }
      }

      resetVotes() {
        if (isOwner() == true) {
          fetch('http://localhost:4000/api/reset/' + getRoomId(), {
              method: 'PUT',
              headers: {
                  'Content-Type': 'application/json',
              },
          })
          .catch((error) => {
              console.error('Error:', error);
          });
        }
      }
    }

    class WebsocketHandler {
      setupSocket() {
        this.socket = new WebSocket('ws://localhost:4000/ws/' + getRoomId())
  
        this.socket.addEventListener("message", (event) => {
          if (JSON.parse(event.data).message !== "owner_revealed") {
            drawCards(JSON.parse(event.data).room)
          } else {
            let cards = document.querySelectorAll(".card")
            for (let i = 0; i < cards.length; i++) {
              cards[i].classList.toggle('is-flipped')
            }
          }
        })
  
        this.socket.addEventListener("close", () => {
          this.setupSocket()
        })
      }
  
      submit(event, button) {
        event.preventDefault()

        const message = button.value
  
        this.socket.send(
          JSON.stringify({
            data: {vote: message},
          })
        )
      }
    }

    const getRoomId = () => {
      let room_id = window.location.href.split('/').reverse()[0]
        
      if (room_id.includes("?")){
        room_id = room_id.split("?")[0]
      }

      return room_id
    }

    const isOwner = () => {
      if (window.location.href.includes("?owner=true")) {
        return true
      }

      return false
    }

    const drawCards = (room) => {
      let cards = document.querySelector(".votes")
      cards.innerHTML = ""
      
      for (let i = 0; i < room.votes.length; i++) {
        let card = document.createElement('div')
        card.className = 'card' + (room.hidden ? "" : " is-flipped")
        card.innerHTML = `
          <div class="card__face card__face--front">?</div>
          <div class="card__face card__face--back">` + room.votes[i] +`</div>
        `
        cards.appendChild(card)
      }

      if (room.member_count - room.votes.length > 0) {
        for (let i = room.votes.length; i < room.member_count; i++) {
          let card = document.createElement('div')
          card.className = 'card'
          card.innerHTML = `
            <div class="card-empty"></div>
          `
          cards.appendChild(card)
        }
      }
      
    }
    
    const requestHandler = new RequestHandler()
    const websocketClass = new WebsocketHandler()
    websocketClass.setupSocket()

    if (isOwner() == false) {
      document.getElementById("reveal").parentNode.parentNode.removeChild(document.getElementById("reveal").parentNode)
    } else {
      document.getElementById("reveal")
      .addEventListener("click", () => requestHandler.revealVotes())

      document.getElementById("reset")
      .addEventListener("click", () => requestHandler.resetVotes())
    }

    document.getElementById("button-0")
      .addEventListener("click", (event) => websocketClass.submit(event, document.getElementById("button-0")))
    document.getElementById("button-1")
      .addEventListener("click", (event) => websocketClass.submit(event, document.getElementById("button-1")))
    document.getElementById("button-2")
      .addEventListener("click", (event) => websocketClass.submit(event, document.getElementById("button-2")))
    document.getElementById("button-3")
      .addEventListener("click", (event) => websocketClass.submit(event, document.getElementById("button-3")))
    document.getElementById("button-5")
      .addEventListener("click", (event) => websocketClass.submit(event, document.getElementById("button-5")))
    document.getElementById("button-8")
      .addEventListener("click", (event) => websocketClass.submit(event, document.getElementById("button-8")))
    document.getElementById("button-13")
      .addEventListener("click", (event) => websocketClass.submit(event, document.getElementById("button-13")))
    document.getElementById("button-21")
      .addEventListener("click", (event) => websocketClass.submit(event, document.getElementById("button-21")))
  })()
