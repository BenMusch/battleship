const opponent = (state={}) => {
  switch(action.type) {
    case 'UPDATE_OPPONENT':
      return action.opponent
    default:
      return state
  }
}

export default opponent
