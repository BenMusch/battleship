import uuid from 'uuid/v1'
import React from 'react'

import socket from '../socket'

class CreateGame extends React.Component {
  constructor() {
    super()
    this.state = { joinCode: '' }
  }

  updateJoinCode(event) {
    this.setState({joinCode: event.target.value})
  }

  handleCreate(event) {
    event.preventDefault()
    this.join(uuid())
  }

  handleJoin(event) {
    event.preventDefault()
    this.join(this.state.joinCode)
  }

  join(gameId) {
    let channel = socket.channel(`game:${gameId}`)

    channel.join()
      .receive('ok', resp => {
        console.log(resp)
        this.props.joinGame(resp.id, channel)
        this.props.updateBoard(resp.board)
        this.props.updateOpponent(resp.opponent)
      })
      .receive('error', resp => {
        alert('Full game!')
      })

    channel.on('update', resp => {
      console.log(resp)
      this.props.updateBoard(resp.board)
      this.props.updateOpponent(resp.opponent)
    })
  }

  render() {
    return (
      <div className="create-game">
        <center>
          <button className="btn btn-primary" onClick={this.handleCreate.bind(this)}>Create a Game</button>
          <span>Or</span>
          <form className="form-inline" onSubmit={this.handleJoin.bind(this)}>
            <input type="text" className="form-control" placeholde="Join code"
              value={this.state.joinCode} onChange={this.updateJoinCode.bind(this)}/>
            <input type="submit" value="Join Game!"/>
          </form>
        </center>
      </div>
    )
  }
}

export default CreateGame
