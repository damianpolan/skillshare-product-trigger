# frozen_string_literal: true

class HomeController < ApplicationController
  include ShopifyApp::EmbeddedApp
  include ShopifyApp::RequireKnownShop
  include ShopifyApp::ShopAccessScopesVerification

  def index
    @shop_origin = current_shopify_domain
    @host = params[:host]

    session = Shop.retrieve_by_shopify_domain(@shop_origin)
    ShopifyAPI::Session.with_session(session) do
      all_products = ShopifyAPI::Product.find(:all)

      @premium_count = all_products.count do |product|
        product.tags.split(',').include?(ProductsCreateJob::PREMIUM_PRODUCT_TAG)
      end
      @not_premium_count = all_products.count - @premium_count
    end

    shop = Shop.find_by(shopify_domain: @shop_origin)
    @current_premium = shop.minimum_premium_price || 0
  end

  def new_premium
    @shop_origin = current_shopify_domain
    shop = Shop.find_by(shopify_domain: @shop_origin)

    shop.update!(minimum_premium_price: params[:premium])

    redirect_to root_path(request.parameters)
  end
end
