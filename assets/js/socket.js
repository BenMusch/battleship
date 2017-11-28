import uuid from 'uuid/v1'
import {Socket} from 'phoenix'

window.player_uuid = uuid()
let socket = new Socket('/socket', {params: {player_id: window.player_uuid}})
socket.connect()

window.game_uuid = uuid()
let channel = socket.channel(`game:${window.game_uuid}`)


export default channel
