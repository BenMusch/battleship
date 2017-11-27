import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {}})
socket.connect()

let channel = socket.channel("game:join")

export default channel
