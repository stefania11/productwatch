class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :url
      t.string :location
    end
  end
end
