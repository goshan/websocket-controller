module WebSocket
	class Controller
		def before_filter(params)
			return true
		end

		def send_message(json, user_id)
			msg = JSON.generate json
			ws = WebSocket::Manager.socket_by_user user_id
			if ws
				ws.send msg
				puts "send message to user: #{user_id} with signature: #{ws.signature}: #{json}"
			else
				puts "send message failed for no socket found. user: #{user_id}, json: #{json}"
			end
		end

		def broadcast_message(json)
			msg = JSON.generate json
			WebSocket::Manager.all_sockets.each do |ws|
				ws.send msg
			end
			puts "broadcast to all sockets: #{json}"
		end
	end
end
