const player = (state = {}, action) => {
  switch(action.type) {
    case 'JOIN_GAME':
      return { joining: false, id: action.id }
    case 'FAIL_JOIN':
      return { joining: false }
    default:
      return state
  }
}

export default player
