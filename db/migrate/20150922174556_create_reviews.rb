class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.string :title
      t.text :content
      t.string :rating
      t.date :date
      t.string :votes
      t.string :low_sentence
      t.float  :low_score
      t.string :high_sentence
      t.float  :high_score
      t.string :overall_sentiment
      t.float  :overall_score
      t.belongs_to :product, index: true, foreign_key: true
      t.belongs_to :author, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
