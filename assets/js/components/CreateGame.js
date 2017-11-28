window.game_uuid = uuid()
let channel = socket.channel(`game:${window.game_uuid}`)

import React from 'react'

class CreateGame extends React.Component {
  constructor() {
    super()
    this.state = { joinCode: '' }
  }

  updateJoinCode(event) {
    this.setState({joinCode: event.target.value})
  }

  createGame(event) {
    event.preventDefault()
    this.setState({joinCode: uuid()})
    this.joinGame(event)
  }

  joinGame(event) {
    let channel = socket.channel(`game:${this.state.joinCode}`)

  }

  render() {
    return (
      <div className="create-game">
        <center>
          <button className="btn btn-primary">Create a Game</button>
          <span>Or</span>
          <form className="form-inline" onSubmit={this.joinGame}>
            <input type="text" className="form-control" placeholde="Join code"
              value={this.state.joinCode} onChange={this.updateJoinCode}/>
            <input type="submit" value="Join Game!"/>
          </form>
        </center>
      </div>
    )
  }
}
