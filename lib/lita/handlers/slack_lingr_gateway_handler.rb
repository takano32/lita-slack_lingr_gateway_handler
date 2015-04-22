module Lita
  module Handlers
    class SlackLingrGatewayHandler < Handler
      route /^(.+)$/, :slack_to_lingr

      def slack_to_lingr(response)
        say  = 'http://lingr.com/api/room/say'
        room = 'arakawatomonori'
        bot  = 'slack'
        text = URI.encode([response.user.mention_name, response.matches.join].join ": ")
        bot_verifier = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
        url  = '%s?room=%s&bot=%s&text=%s&bot_verifier=%s' %
          [say, room, bot, text, bot_verifier]
        uri = URI.parse url
        Net::HTTP.get(uri)
      end

      http.post '/', :pass
      def pass(request, response)
        require 'json'
        req = JSON.parse request.body.read
        events = req['events']
        events.each do |event|
          message = event['message']
          room = message['room']
          speaker_id = message['speaker_id']
          nickname = message['nickname']
          text = message['text']
          puts [room, speaker_id, nickname, text]
          puts
          target = Lita::Source.new(room: '#general')
          robot.send_message(target, "#{nickname}: #{text}")
          # response.body << "#{nickname}: #{text}"
        end
      end

      def lingr_to_slack(request, response)
        response.body << "Hello, #{request.user_agent}!"
      end

      on(:connected) do |payload|
        target = Source.new(room: '#general')
        robot.send_message(target, 'Hi')
      end
    end

    Lita.register_handler(SlackLingrGatewayHandler)
  end
end
