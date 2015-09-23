class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title
      t.string :asin
      t.string :image_url

      t.timestamps null: false
    end
  end
end
