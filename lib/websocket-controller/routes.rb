module WebsocketController
	class Route
		@@routes = {}

		class << self
			def init
				@@routes = {}
			end

			def setup
				yield
			end

			def engin(engin, actions)
				@@routes[engin] = actions
			end
		end
		 
	end
end
