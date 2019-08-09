# Copyright Erisa Arrowsmith 2019
module YuukiBot
  module Helper

    def self.calc_exp(userid)
      exp = REDIS.hget('exp', userid).to_i
      exp = 0 if exp.nil?
      newexp = exp + rand(5..30)
      REDIS.hset('exp', userid, newexp)
    end

  end
end