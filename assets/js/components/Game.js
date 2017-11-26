import React from 'react'
import channel from "../socket"

class Game extends React.Component {
  mainMessage() {
    if (this.props.player.joining) {
      return 'Joining...'
    } else if (this.props.player.id) {
      return `ID: ${this.props.player.id}`
    } else {
      return 'Full game!'
    }
  }

  componentDidMount() {
    channel.join()
      .receive("ok", resp => console.log(resp) || this.props.joinGame(resp.player.id))
      .receive("error", resp => this.props.failJoin())
  }

  render() {
    return (
      <div className="app-container">
        {this.mainMessage()}
      </div>
    )
  }
}

export default Game
