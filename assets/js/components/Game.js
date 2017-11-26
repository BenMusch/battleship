import React from 'react'
import socket from "../socket"

class Game extends React.Component {
  mainDisplay() {
    if (this.props.player.joining) {
      return React.createElement('p', {}, 'Joining...')
    } else if (this.props.player.id) {
      return React.createElement('p', {}, `Joined as ${this.props.player.id}`)
    } else {
      return React.createElement('p', {}, 'Full game!')
    }
  }

  componentDidMount() {
    let channel = socket.channel("game:join")
    channel.join()
      .receive("ok", resp => {
        console.log(resp)
        this.props.joinGame(resp.player.id)
        this.props.updateBoard(resp.board)
        this.props.updateOpponent(resp.opponent)
      })
      .receive("error", resp => this.props.failJoin())
  }

  render() {
    return (
      <div className="app-container">
        {this.mainDisplay()}
      </div>
    )
  }
}

export default Game
