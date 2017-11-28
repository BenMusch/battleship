const game = (state = {}, action) => {
  console.log(action, state)
  switch(action.type) {
    case 'JOIN_GAME':
      return { id: action.id }
    default:
      return state
  }
}

export default game
