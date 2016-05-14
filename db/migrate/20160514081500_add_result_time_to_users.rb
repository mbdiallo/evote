class AddResultTimeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :result_time, :boolean, default: false
  end
end
