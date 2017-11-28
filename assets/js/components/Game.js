import React from 'react'

import channel from '../socket'
import Boards from "./Boards"
import CreateGame from "./CreateGame"

class Game extends React.Component {
  mainDisplay() {
    if (this.props.game.id && this.props.opponent.id) {
      return <Boards channel={this.props.game.channel} player={this.props.board} opponent={this.props.opponent} updateBoard={this.props.updateBoard} updateOpponent={this.props.updateOpponent} />
    } else if (this.props.game.id) {
      return React.createElement('p', {}, `Waiting for opponent... Code: ${this.props.game.id}`)
    } else {
      return <CreateGame joinGame={this.props.joinGame} updateBoard={this.props.updateBoard} updateOpponent={this.props.updateOpponent} />
    }
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
