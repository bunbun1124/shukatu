class CreateStars < ActiveRecord::Migration[6.1]
  def change
    create_table :stars do |t|
      t.string :name
      t.string :username
      t.integer :overall
      t.integer :level

      t.timestamps
    end
  end
end
