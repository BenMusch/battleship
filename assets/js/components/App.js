import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import * as actionCreators from '../actions'
import Game from './Game'

const mapStateToProps = (state) => {
  return {
    player: state.player,
    opponent: state.opponent,
    board: state.board
  }
}

const mapDispatchToProps = (dispatch) => {
  return bindActionCreators(actionCreators, dispatch)
}

const App = connect(mapStateToProps, mapDispatchToProps)(Game)

export default App
