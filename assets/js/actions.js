export const setUser = (id) => {
  return {
    type: 'SET_USER',
    id: id
  }
}

export const joinGame = () => {
  return {
    type: 'JOIN_GAME',
    id: id
  }
}

export const failJoin = () => {
  return {
    type: 'FAIL_JOIN'
  }
}

export const updateBoard = (board) => {
  return {
    type: 'UPDATE_BOARD',
    board
  }
}

export const updateOpponent = (opponent) => {
  return {
    type: 'UPDATE_OPPONENT',
    opponent
  }
}
