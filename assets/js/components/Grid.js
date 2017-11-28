import React from 'react'

import socket from '../socket'
import constants from '../battleship/constants'

const classFromStatus = {
  [constants.SHIP]: 'bg-primary',
  [constants.GUESSED]: 'bg-secondary',
  [constants.SUNK]: 'bg-danger',
  [constants.HIT]: 'bg-warning'
}

class Tile extends React.Component {
  classFromStatus(status) {
    let baseClass = classFromStatus[status] || 'bg-light'
    return `${baseClass} border tile`
  }

  render() {
    let className = this.classFromStatus(this.props.status)
    return (
      <td className={className} onClick={this.props.onClick}></td>
    )
  }
}

class Grid extends React.Component {
  constructor() {
    super()
    this.state = { head: null }
  }

  handleGuess(x, y) {
    this.props.channel.push('guess', { x, y })
      .receive('ok', resp => {
        console.log(resp)
        this.props.updateBoard(resp.board)
        this.props.updateOpponent(resp.opponent)
      })
      .receive('error', resp => window.alert(resp.reason))
  }

  handlePlace(x, y) {
    if (this.state.head) {
      console.log('PLACING', this.state.head, [x, y])
      this.props.channel.push('place', {
        x1: this.state.head[0],
        y1: this.state.head[1],
        x2: x,
        y2: y
      }).receive('ok', resp => {
        console.log(resp)
        this.props.updateBoard(resp.board)
        this.props.updateOpponent(resp.opponent)
      }).receive('error', resp => window.alert(resp.reason))

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
        return <Tile onClick={this.handleClick.bind(this, x, y)} key={x} status={square}/>
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
