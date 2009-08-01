class CreateGraceUser < ActiveRecord::Migration
  def self.up
    User.create(:login => "graciewacie", :email => "gracechow316@gmail.com", :password => "yenoh2009", :password_confirmation => "yenoh2009")
  end

  def self.down
    User.find_by_login("graciewacie").destroy
  end
end
