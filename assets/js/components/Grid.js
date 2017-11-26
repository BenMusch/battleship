import React from 'react'
import { NOT_GUESSED, GUESSED, HIT, SUNK } from '../battleship/constants'

class Tile extends React.Component {
  classFromState() {
    let defaults = 'border tile'
    switch(this.props.state) {
      case NOT_GUESSED:
        return `bg-light ${defaults}`
      case GUESSED:
        return `bg-secondary ${defaults}`
      case HIT:
        return `bg-warning ${defaults}`
      case SUNK:
        return `bg-danger ${defaults}`
      default:
        return `bg-light ${defaults}`
    }
  }

  render() {
    return (
      <td className={this.classFromState()}>
      </td>
    )
  }
}

class Grid extends React.Component {
  render() {
    let rows = this.props.grid.map((row, i) => {
      let tiles = row.map((square, j) => <Tile key={j} state={square}/>)
      return (<tr key={i}>{tiles}</tr>)
    })

    return (
      <table>
        <tbody>
          {rows}
        </tbody>
      </table>
    )
  }
}

export default Grid
