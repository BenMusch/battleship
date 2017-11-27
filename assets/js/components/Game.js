import React from 'react'

import channel from "../socket"
import Boards from "./Boards"

class Game extends React.Component {
  mainDisplay() {
    if (this.props.player.joining) {
      return React.createElement('p', {}, 'Joining...')
    } else if (this.props.player.id) {
      return <Boards player={this.props.board} opponent={this.props.opponent} />
    } else {
      return React.createElement('p', {}, 'Full game!')
    }
  }

  componentDidMount() {
    channel.join()
      .receive("ok", resp => {
        this.props.joinGame(resp.player.id)
        this.props.updateBoard(resp.board)
        this.props.updateOpponent(resp.opponent)
      })
      .receive("error", resp => this.props.failJoin())
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
