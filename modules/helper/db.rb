# Copyright Erisa Komuro (Seriel) 2018
module YuukiBot
  module Helper

    def update_user(
      id: nil,
      is_owner: nil,
      is_donator: nil,
      ignored: nil,
      exp: nil,
      level: nil
    )
      userdata = DB.execute("SELECT * FROM `userlist` WHERE `id` = #{id}")
      if userdata == []
        DB.execute("INSERT INTO userlist (id, is_owner, is_donator, ignored, exp, level) VALUES (#{id}, 0, 0, 0, 0, 0); ")
      end
      dbexec = "UPDATE userlist"
      dbexec << "\n SET is_owner = `#{is_owner}`" unless is_owner.nil?
      dbexec << ",\n SET is_owner = `#{is_donator}`" unless is_donator.nil?
      dbexec << ",\n SET is_owner = `#{ignored}`" unless ignored.nil?
      dbexec << ",\n SET is_owner = `#{exp}`" unless exp.nil?
      dbexec << ",\n SET is_owner = `#{level}`" unless level.nil?
      dbexec << ",\n SET donationamount - `#{donationamount}`" unless donationamount.nil?
      dbexec << "\n WHERE ID = #{id};"

      DB.execute("UPDATE userlist
       SET is_donator = 1
       WHERE id = #{id};"
      )
    end

    def calc_exp(userid)

    end

  end
end