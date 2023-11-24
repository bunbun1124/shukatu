class AddStarsToTweets < ActiveRecord::Migration[6.1]
  def change
    add_column :tweets, :username, :string
    add_column :tweets, :overall, :integer
    add_column :tweets, :level, :integer
  end
end
