# frozen_string_literal: true

module YuukiBot
  module Statistics
    class DiscordBots < GenericService
      attr_accessor :api_key, :server_count

      API_DOMAIN = URI.parse('https://discord.bots.gg')
      API_BASE = '/api/v1'

      def service_name
        'Discord Bots'
      end

      def config_key
        'discord_bots_api_key'
      end

      def check_registration(bot)
        @api_key = YuukiBot.config[config_key]
        raise ServiceMissingTokenError.new, false if @api_key.nil? || @api_key.empty?

        # Send an empty (yet authenticated) request to test for errors.
        id = bot.bot_user
        res = send_statistics_request(id, '')

        # Token and related authentication errors stem from this.
        raise ServiceInvalidTokenError if res.instance_of?(Net::HTTPUnauthorized)

        # This is what we want - this route fails regarding
        # syntax if authenticated.
        return nil if res.instance_of?(Net::HTTPBadRequest)

        # All other errors come down to this.
        raise ServiceGivenError.new res.code, res.body
      end

      def register_statistics(bot)
        count = bot.servers.length
        return if count == @server_count

        # TODO: If sharding is desired, please account for that + its shard ID.
        # See https://discord.bots.gg/docs/endpoints in the future.
        send_statistics_request bot.bot_user, {
          guildCount: count
        }.to_json
        @server_count = count
      end

      def send_statistics_request(profile, contents)
        statistics_route_path = "#{API_BASE}/bots/#{profile.id}/stats"

        request = Net::HTTP::Post.new(statistics_route_path)
        request['Authorization'] = @api_key
        request['Content-Type'] = 'application/json'
        request['User-Agent'] = "#{profile.username}-#{profile.discrim}/#{YuukiBot.version} " \
                                '(discordrb; +https://github.com/Yuuki-Discord/Yuuki-Bot) ' \
                                "DBots/#{profile.id}"

        request.body = contents

        http = Net::HTTP.new(API_DOMAIN.host, API_DOMAIN.port)
        http.use_ssl = true

        # Return full response
        http.request(request)
      end
    end
  end
end
