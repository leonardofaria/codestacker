class AddUserIdToCodes < ActiveRecord::Migration
  def change
    add_reference :codes, :user, index: true, foreign_key: true
  end
end
