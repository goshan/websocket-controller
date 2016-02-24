require "websocket/version"
require "websocket/routes"
require "websocket/manager"
require "websocket/parser"
require "websocket/controller"


module WebSocket
	class Railtie < ::Rails::Railtie
		rake_tasks do 
			load 'tasks/socket.rake'
		end
	end
end

module WebSocket
	Routes.init
end
