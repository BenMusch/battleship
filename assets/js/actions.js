export const joinGame = (id, channel) => {
  return {
    type: 'JOIN_GAME',
    id,
    channel
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
