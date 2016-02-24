module WebSocket
	class Controller
		attr_accessor :params

		def initialize(params)
			@params = params
		end

		def before_filter
			return true
		end
		
		def current_user
			User.find_by_id @params[:user_id]
		end

		def send_message(json, user_id=nil)
			msg = JSON.generate json
			user_id = @params[:user_id] unless user_id
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
