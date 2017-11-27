import React from 'react'

import channel from '../socket'
import { NOT_GUESSED, GUESSED, HIT, SUNK, SHIP } from '../battleship/constants'

class Tile extends React.Component {
  classFromState() {
    let defaults = 'border tile'
    switch(this.props.state) {
      case SHIP:
        return `bg-primary ${defaults}`
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
      <td className={this.classFromState()} onClick={this.props.onClick}></td>
    )
  }
}

class Grid extends React.Component {
  constructor() {
    super()
    this.state = { head: null }
  }

  handleGuess(x, y) {
    // TODO
  }

  handlePlace(x, y) {
    if (this.state.head) {
      console.log('PLACING', this.state.head, [x, y])
      channel.push('place', {
        x1: this.state.head.x,
        y1: this.state.head.y,
        x2: x,
        y2: y
      }).receive("ok", resp => {
        this.props.updateBoard(resp.board)
        this.props.updateOpponent(resp.opponent)
      }).receive("error", resp => window.alert(resp.reason))

      this.setState({ head: null })
    } else {
      this.setState({ head: [x, y] })
    }
  }

  handleClick(x, y) {
    if (this.props.canPlace) {
      this.handlePlace(x, y)
    } else if (this.props.canGuess) {
      this.handleGuess(x, y)
    }
  }

  render() {
    let rows = this.props.grid.map((row, y) => {
      let tiles = row.map((square, x) => {
        return <Tile onClick={this.handleClick.bind(this, x, y)} key={x} state={square}/>
      })
      return (<tr key={y}>{tiles}</tr>)
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
