# Websocket::Controller

a rails controller class make you can write web-socket code

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'websocket-controller'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install websocket-controller

## Usage

### Controller

Make a controller file and write down the code below, and then you can make any action just like rails controller

```ruby
class SomeController < WebSocket::Controller
	# you can write some action method here
end
```

For websoket routes, make a new file in `config/initializers/websocket_routes.rb`.
And declare routes schema like below

```ruby
WebSocket::Routes.setup do
	{
		:some => [
			"enter", 
			"leave", 
			"start"
		],

		:test => [
			"check", 
			"dump"
		]
	}
end
```

And then wirte the action method in the controller with the same name like

```ruby
class SomeController < WebSocket::Controller
	def enter
		# action logic
	end

	def leave
		# action logic
	end

	def start
		# action logic
	end
end

class TestController < WebSocket::Controller
	def check
		# action logic
	end

	def dump
		# action logic
	end
end
```

> Be careful, web socket will not access action without declaring routes

If you want to get the parameters from client, just do this in action

```ruby
param1 = params[:param1]
param2 = params[:param2]
```

`params[:user_id]` was created by default with web socket client signature
And also you can use `current_user` directly to get current client user. This feature is require you to migrate a `User` table and model

### Task

start web socket server with command

```shell
$ be rake socket:start
```

and stop with `Ctrl-C`

### JS

make a connection to web socket server with code below

```javascript
socket = new WebSocket(url);

socket.onopen = function(event){
	// important! make sure register to bind user_id with this socket
	var json = {engin: "socket", action: "register", user_id: user_id}
	var request = JSON.stringify(json);
	socket.send(request);
};
	
socket.onmessage = function(event) { 
	// get web socket server response
	var res = $.parseJSON(event["data"]);
	console.log(res);
}; 

socket.onclose = function(event) { 
	// when socket was closed
	console.log('Client notified socket has closed',event); 
};
```

And send a message with format

```javascript
	var json = {engin: "controller", action: "action", other_params: params}
	var request = JSON.stringify(json);
	socket.send(request);
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

