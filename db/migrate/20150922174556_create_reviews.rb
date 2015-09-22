class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.string :title
      t.text :content
      t.string :rating
      t.date :date
      t.string :votes
      t.string :author
      t.belongs_to :product, index: true, foreign_key: true
      t.belongs_to :author, index: true, foreign_key: true
    end
  end
end
