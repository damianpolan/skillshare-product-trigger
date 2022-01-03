class ProductsCreateJob < ActiveJob::Base
  PREMIUM_PRODUCT_MINUMUM_PRICE = 50.00
  PREMIUM_PRODUCT_TAG = 'premium'

  def perform(params)
    session = Shop.retrieve_by_shopify_domain(params[:shop_domain])
    ShopifyAPI::Session.with_session(session) do
      product_id = params.dig(:webhook, :id)
      product = ShopifyAPI::Product.find(product_id)

      add_premium_tag_maybe(product)
    end
  end

  private

  def add_premium_tag_maybe(product)
    product.variants.each do |variant|
      if variant.price.to_d >= PREMIUM_PRODUCT_MINUMUM_PRICE
        add_tag(product, PREMIUM_PRODUCT_TAG)
        return product.save
      end
    end
  end

  def add_tag(product, tag)
    # shopify will automatically de-dup tags, and handle extra comma at beginning of string.
    product.tags += ",#{tag}"
  end
end

