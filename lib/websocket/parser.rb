module WebSocket
  class Parser
    def self.parse_message(msg, ws)
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
      action = json[:action]

      if json[:engin] == "socket" && json[:action] == "register"
        # register user with ws
        WebSocket::Manager.bind_socket json[:user_id].to_i, ws
      elsif WebSocket::Routes.include_engin?(engin) && WebSocket::Routes.include_action?(engin, action)
        # run engin controller
        json[:user_id] = WebSocket::Manager.user_by_socket ws
        controller = "#{json[:engin].capitalize}Controller".constantize.send('new', json)
        if controller.before_filter
          controller.send(json[:action])
        end
      else
        # 404 error
        response = JSON.generate({:status => 'error', :error => "unsupport engin or action"})
        ws.send(response)
      end
    end

    def self.close_socket(ws)
      WebSocket::Manager.unbind_socket ws
    end
  end
end
