namespace :update_database do
  task :daily do
    Rake::Task["environment"].execute
    Product.all.each do |product|
      product.reviews.each do |review|
        review.destroy
      end
      ReviewParser.call(product.asin, product.id)
    end
  end
end
