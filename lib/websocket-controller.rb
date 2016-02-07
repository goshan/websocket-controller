require "websocket/controller/version"

module WebsocketController

	WebscoketController::Routes.init

	def routes
		WebscoketController::Routes.setup do
			yield
		end
	end

end
