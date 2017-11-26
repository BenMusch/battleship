export const joinGame = (id) => {
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
