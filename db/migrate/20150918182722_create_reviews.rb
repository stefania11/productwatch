class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.text :data
      t.belongs_to :search, index: true, foreign_key: true
    end
  end
end
