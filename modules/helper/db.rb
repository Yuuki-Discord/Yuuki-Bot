# Copyright Erisa Komuro (Seriel) 2018
module YuukiBot
  module Helper

    def self.update_user(
      id: nil,
      is_owner: nil,
      is_donator: nil,
      ignored: nil,
      exp: nil,
      level: nil,
      donationamount: nil
    )
      userdata = DB.execute("SELECT * FROM `userlist` WHERE `id` = #{id}")
      if userdata == [] || userdata.nil?
        DB.execute("INSERT INTO userlist (id, is_owner, is_donator, ignored, exp, level) VALUES (#{id}, 0, 0, 0, 0, 1); ")
      end
      dbexec = "UPDATE userlist"

      is_owner = get_data(id, 'is_owner') if is_owner.nil?

      dbexec << "\n SET is_owner = #{is_owner}" unless is_owner.nil?
      dbexec << ",is_donator = #{is_donator}" unless is_donator.nil?
      dbexec << ",ignored = #{ignored}" unless ignored.nil?
      dbexec << ",exp = #{exp}" unless exp.nil?
      dbexec << ",level = #{level}" unless level.nil?
      dbexec << ",donationamount - #{donationamount}" unless donationamount.nil?
      dbexec << "\n WHERE id = #{id};"

      DB.execute(dbexec)
    end

    def self.calc_exp(userid)
      exp = get_data(userid, 'exp')
      exp = 0 if exp.nil? or exp = []
      newexp = exp + rand(5..30)
      update_user(id: userid, exp: newexp)
    end

    def self.get_data(userid, data)
      if DB.execute("SELECT * FROM `userlist` WHERE `id` = #{userid}") == [] || DB.execute("SELECT * FROM `userlist` WHERE `id` = #{userid}").nil?
        DB.execute("INSERT INTO userlist (id, is_owner, is_donator, ignored, exp, level) VALUES (#{userid}, 0, 0, 0, 0, 0); ")
      end
      DB.execute("SELECT #{data} FROM userlist WHERE id = #{userid}")[0][0]
    end
  end
end