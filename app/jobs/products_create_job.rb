class ProductsCreateJob < ActiveJob::Base
  def perform(params)

    puts "PRODUCTS CREATE JOB"
  end
end

