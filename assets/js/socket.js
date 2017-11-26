import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {}})
socket.connect()

let channel = socket.channel("player:game", {})

export default channel
