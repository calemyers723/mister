class AddUnsubscribeFieldToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_unsubscribe, :boolean, default: false
  end
end
