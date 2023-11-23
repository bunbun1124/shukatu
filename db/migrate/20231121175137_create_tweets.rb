class CreateTweets < ActiveRecord::Migration[6.1]
  def change
    create_table :tweets do |t|
      t.string :name
      t.string :graduation
      t.string :title
      t.date :date
      t.text :about

      t.timestamps
    end
  end
end
