class AddImageToVotes < ActiveRecord::Migration
  def change
    add_column :votes, :image, :string
  end
end
