const player = (state = {}, action) => {
  switch(action.type) {
    case 'JOIN_GAME':
      state.joining = false
      state.id = action.id
      return state
    case 'FAIL_JOIN':
      state.joining = false
      return state
    default:
      return state
  }
}

export default player
