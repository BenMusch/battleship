import React from 'react'

import channel from "../socket"
import Boards from "./Boards"

class Game extends React.Component {
  mainDisplay() {
    if (this.props.player.joining) {
      return React.createElement('p', {}, 'Joining...')
    } else if (this.props.player.id && this.props.opponent.id) {
      return <Boards player={this.props.board} opponent={this.props.opponent} />
    } else if (this.props.player.id) {
      return React.createElement('p', {}, 'Waiting for opponent...')
    } else {
      return React.createElement('p', {}, 'Full game!')
    }
  }

  componentDidMount() {
    channel.join()
      .receive('ok', resp => {
        channel.push('confirm_join', {})
        this.props.joinGame(resp.player.id)
        this.props.updateBoard(resp.board)
        this.props.updateOpponent(resp.opponent)
      })
      .receive('error', resp => this.props.failJoin())

    channel.on('update', resp => {
      console.log(resp)
      this.props.updateBoard(resp.board)
      this.props.updateOpponent(resp.opponent)
    })
  }

  render() {
    return (
      <div className="app-container container">
        {this.mainDisplay()}
      </div>
    )
  }
}

export default Game
