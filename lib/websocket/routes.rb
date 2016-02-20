module WebSocket
	class Routes
		@@routes = {}

		class << self
			def init
				@@routes = {}
			end

			def setup
				@@routes = yield
			end

			def include_engin?(engin)
				@@routes.keys.include? engin
			end

			def include_action?(engin, action)
				@@routes[engin].include? action
			end
		end
		 
	end
end
