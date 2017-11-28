import uuid from 'uuid/v1'
import {Socket} from 'phoenix'

window.player_uuid = uuid()
let socket = new Socket('/socket', {params: {player_id: window.player_uuid}})
socket.connect()

export default socket
