export const joinGame = () => {
  return {
    type: 'JOIN_GAME'
  }
}

export const placeShip = (head, tail) => {
  return {
    type: 'PLACE_SHIP',
    head,
    tail
  }
}

export const guess = (x, y) => {
  return {
    type: 'GUESS',
    x,
    y
  }
}
