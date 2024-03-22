# frozen_string_literal: true

module YuukiBot
  module Statistics
    attr_accessor :running_statistics

    def self.require_services
      Dir['./modules/statistics/services/*.rb'].each do |r|
        require r
        puts "Loaded service: #{r}" if YuukiBot.config['verbose']
      end
    end

    # Loops through a static list of handler types to register.
    def self.register_statistics_callbacks(bot)
      # We need our list of running statistics to be an array.
      @running_statistics = []
      require_services

      # List of classes we can potentially use as handlers.
      statistic_classes = [
        DiscordBots.new
      ].freeze

      # All handlers (should) implement StandardService.
      # Use all methods available from its base implementation.
      statistic_classes.each do |handler|
        service_failed = begin
          handler.check_registration(bot)
          false
        rescue NotImplementedError
          log 'A service did not have a method implemented! Please debug.'
          true
        rescue ServiceMissingTokenError
          # We do not need to log. This service should be treated as disabled.
          true
        rescue StandardError => e
          log "Service #{handler.service_name} reported an error: #{e.message}"
          log e.backtrace.join("\n")
          true
        end

        unless service_failed
          log "Adding #{handler.service_name} as a service!"
          @running_statistics.push(handler)
        end
      end

      # It's useless to run a timer if no services are added.
      update_statistics bot unless @running_statistics.empty?
    end

    # Create a timer every 5 minutes to cycle through
    def self.update_statistics(bot)
      running_mutex = Mutex.new
      Thread.new do
        loop do
          running_mutex.synchronize do
            # Sleep thread for 5 minutes
            sleep 5 * 60

            @running_statistics.each do |service|
              service.register_statistics bot
            end
          end
        end
      end
    end

    def self.log(message)
      puts "[STATISTICS] #{message}"
    end
  end
end
