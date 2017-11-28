export const joinGame = () => {
  return {
    type: 'JOIN_GAME',
    id: id
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
