class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.boolean :show_time, default: false
      t.timestamps null: false
    end
  end
end
