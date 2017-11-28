const game = (state = {}, action) => {
  switch(action.type) {
    case 'JOIN_GAME':
      console.log(action)
      return { id: action.id, channel: action.channel }
    default:
      return state
  }
}

export default game
