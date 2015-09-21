class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :query
    end
  end
end
