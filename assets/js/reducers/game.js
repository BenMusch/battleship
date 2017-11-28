const player = (state = {}, action) => {
  switch(action.type) {
    case 'JOIN_GAME':
      return { id: action.id, joining: false }
    case 'FAIL_JOIN':
      return { joining: false }
    default:
      return state
  }
}

export default player
