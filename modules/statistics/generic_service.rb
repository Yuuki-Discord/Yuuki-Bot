# frozen_string_literal: true

module YuukiBot
  module Statistics
    class GenericService
      attr_accessor :api_key

      def service_name
        raise NotImplementedError
      end

      def config_key
        raise NotImplementedError
      end

      def check_registration(_bot, _api_key)
        raise NotImplementedError
      end

      def register_statistics(_bot)
        raise NotImplementedError
      end
    end

    class ServiceInvalidTokenError < StandardError
      def message
        'Token was reported to be invalid.'
      end
    end

    # This exception should not be displayed, and instead silently ignored
    # as no token for a service should equate to it being cancelled.
    class ServiceMissingTokenError < StandardError
      def message
        'Token was not provided.'
      end
    end

    class ServiceGivenError < StandardError
      attr_reader :res

      def initialize(res)
        super
        @res = res
      end

      def message
        "Service returned error code #{res.code}: #{res.body}"
      end
    end
  end
end
