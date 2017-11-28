import uuid from 'uuid/v1'
import {Socket} from 'phoenix'

let socket = new Socket('/socket', {params: {}})
socket.connect()

window.uuid = uuid()
let channel = socket.channel(`player:${window.uuid}`)


export default channel
