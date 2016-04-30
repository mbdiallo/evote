class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|

      t.string :candidate_name
      t.integer :count, default: 0, null: false
      t.timestamps null: false
    end
  end
end
