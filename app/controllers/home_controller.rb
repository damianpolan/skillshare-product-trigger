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
  end
end
