import React from 'react'

import Grid from './Grid'

class Boards extends React.Component {
  renderShips(ships) {
    return ships.map((ship, i) => <li key={i}>{ship}</li>)
  }

  canGuess() {
    this.props.player.unplaced_ships.length + this.props.opponent.unplaced_ships.length == 0
  }

  render() {
    return (
      <div className="row">
        <div className="col-md-6 row">
          <div className="col-md-4">
            <h4 className="text-center">You</h4>
            <span>Unplaced ships:</span>
            <ul>
              {this.renderShips(this.props.player.unplaced_ships)}
            </ul>
          </div>

          <div className="col-md-8">
            <Grid
              grid={this.props.player.grid}
              canPlace={this.props.player.unplaced_ships.length > 0}
              canGuess={false}
            />
          </div>
        </div>
        <div className="col-md-6 row">
          <div className="col-md-8">
            <Grid
              grid={this.props.opponent.grid}
              canPlace={false}
              canGuess={this.canGuess()}
            />
          </div>

          <div className="col-md-4">
            <h4 className="text-center">Opponent</h4>
            <span>Unplaced ships:</span>
            <ul>
              {this.renderShips(this.props.opponent.unplaced_ships)}
            </ul>
          </div>
        </div>
      </div>
    )
  }
}

export default Boards
