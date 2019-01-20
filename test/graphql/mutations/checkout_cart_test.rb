require 'test_helper'

module Mutations
  class CheckoutCartTest < ActiveSupport::TestCase
    def perform(_args)
      Mutations::CheckoutCart.new(object: nil, context: { current_cart: @cart }).resolve
    end

    setup do
      # Create mock products with zero to some inventory
      @product1 = Product.create! id: 1, title: 'Boots', price: 59.99, inventory_count: 5
      @product2 = Product.create! id: 2, title: 'Shield', price: 99.99, inventory_count: 1
      @product3 = Product.create! id: 3, title: 'Sword', price: 49.99, inventory_count: 0

      @cart = Cart.create!
    end
  end
end
