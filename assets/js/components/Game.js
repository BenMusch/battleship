import React from 'react'

import channel from '../socket'
import Boards from "./Boards"
import CreateGame from "./CreateGame"

class Game extends React.Component {
  mainDisplay() {
    if (this.props.game.joining) {
      return React.createElement('p', {}, 'Joining...')
    } else if (this.props.game.id && this.props.opponent.id) {
      return <Boards player={this.props.board} opponent={this.props.opponent} updateBoard={this.props.updateBoard} updateOpponent={this.props.updateOpponent} />
    } else if (this.props.game.id) {
      return React.createElement('p', {}, 'Waiting for opponent...')
    } else {
      return <CreateGame {...this.props} />
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
