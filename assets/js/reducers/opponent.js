const opponent = (state={}, action) => {
  switch(action.type) {
    case 'UPDATE_OPPONENT':
      return action.opponent
    default:
      return state
  }
}

export default opponent
