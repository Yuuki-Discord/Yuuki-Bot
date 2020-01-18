# Copyright Erisa A 2019-2020
module YuukiBot
  module Helper

    # Relatively simple, but repeated in a lot of places.
    def self.owners
      JSON.parse(REDIS.get('owners')) rescue []
    end

  end
end