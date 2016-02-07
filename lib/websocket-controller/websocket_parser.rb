class SocketParser

	SOCKET_ROUTES = {
		:room => ["enter", "leave", "start_game"], 
		:game => ["enter_game", "get_players", "assign_heroes", "check_hero", "deploy_hero", "ready", "move", "standby", "attack"]
	}

	class << self
		def parse_message(msg, ws)
			# parse json
			begin
				json = JSON.parse msg, {:symbolize_names => true}
			rescue JSON::ParserError
				response = JSON.generate({:status => 'error', :error => "json format error"})
				ws.send(response)
				return
			end

			# check engin and action params
			unless json[:engin] && json[:action]
				response = JSON.generate({:status => 'error', :error => "engin or action missing"})
				ws.send(response)
				return
			end
			engin = json[:engin].to_sym

			if json[:engin] == "socket" && json[:action] == "register"
				# register user with ws
				SocketManager.bind_socket json[:user_id].to_i, ws
			elsif SOCKET_ROUTES.keys.include?(engin) && SOCKET_ROUTES[engin].include?(json[:action])
				# run engin controller
				json[:user_id] = SocketManager.user_by_socket ws
				if "#{json[:engin].capitalize}WSController".constantize.send("before_filter", json)
					"#{json[:engin].capitalize}WSController".constantize.send(json[:action], json)
				end
			else
				# 404 error
				response = JSON.generate({:status => 'error', :error => "unsupport engin or action"})
				ws.send(response)
			end
		end
	end
end
