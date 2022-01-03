class ProductsCreateJob < ActiveJob::Base
  PREMIUM_PRODUCT_MINUMUM_PRICE = 50.00
  PREMIUM_PRODUCT_TAG = 'premium'

  def perform(params)
    @shop_origin = params[:shop_domain]
    @shop = Shop.find_by(shopify_domain: @shop_origin)

    session = Shop.retrieve_by_shopify_domain(@shop_origin)
    ShopifyAPI::Session.with_session(session) do
      product_id = params.dig(:webhook, :id)
      @product = ShopifyAPI::Product.find(product_id)

      add_premium_tag_maybe
    end
  end

  private

  def add_premium_tag_maybe
    @product.variants.each do |variant|
      if variant.price.to_d >= @shop.minimum_premium_price
        add_premium_product_tag
        return @product.save
      end
    end
  end

  def add_premium_product_tag
    # shopify will automatically de-dup tags, and handle extra comma at beginning of string.
    @product.tags += ",#{PREMIUM_PRODUCT_TAG}"
  end
end

