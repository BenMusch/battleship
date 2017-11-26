import React from 'react'

import Grid from './Grid'

class Boards extends React.Component {
  render() {
    return (
      <div className="row">
        <div className="col-md-6">
          <h4 className="text-center">You</h4>

          <Grid grid={this.props.player.grid} />
        </div>
        <div className="col-md-6">
          <h4 className="text-center">Opponent</h4>

          <Grid grid={this.props.opponent.grid} />
        </div>
      </div>
    )
  }
}

export default Boards
