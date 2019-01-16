require 'test_helper'

class Mutations::AddToCartTest < ActiveSupport::TestCase
  def perform(args)
    Mutations::AddToCart.new(object: nil, context: { current_cart: @cart }).resolve(
      **args
    )
  end

  setup do
    # Create mock products with zero to some inventory
    @product1 = Product.create! id: 1, title: "Boots", price: 59.99, inventory_count: 5
    @product2 = Product.create! id: 2, title: "Shield", price: 99.99, inventory_count: 1
    @product3 = Product.create! id: 3, title: "Sword", price: 49.99, inventory_count: 0

    @cart = Cart.create!
  end

  test 'successfully add an item to cart' do
    result = perform(
      product_id: @product1.id,
      quantity: 1
    )

    assert_equal 0, result[:user_errors].count
    assert_equal 1, result[:cart].cart_items.count

    assert_equal 1, result[:cart].cart_items.first.quantity
    assert_equal @product1.title, result[:cart].cart_items.first.product.title

    assert_equal @product1.price, result[:cart].subtotal
  end

  test 'successfully update cart_item quantity' do
    result = perform(
      product_id: @product1.id,
      quantity: 1
    )

    assert_equal 0, result[:user_errors].count
    assert_equal 1, result[:cart].cart_items.count

    assert_equal 1, result[:cart].cart_items.first.quantity
    assert_equal @product1.title, result[:cart].cart_items.first.product.title

    assert_equal @product1.price, result[:cart].subtotal

    result = perform(
      product_id: @product1.id,
      quantity: 1
    )

    assert_equal 0, result[:user_errors].count
    assert_equal 1, result[:cart].cart_items.count

    assert_equal 2, result[:cart].cart_items.first.quantity
    assert_equal @product1.title, result[:cart].cart_items.first.product.title

    assert_equal @product1.price * 2, result[:cart].subtotal
  end

  test 'successfully add multiple items to cart' do
    perform(
      product_id: @product1.id,
      quantity: 2
    )

    result = perform(
      product_id: @product2.id,
      quantity: 1
    ) 

    assert_equal 0, result[:user_errors].count

    assert_equal 2, result[:cart].cart_items.first.quantity
    assert_equal @product1.title, result[:cart].cart_items.first.product.title

    assert_equal 1, result[:cart].cart_items.second.quantity
    assert_equal @product2.title, result[:cart].cart_items.second.product.title

    assert_equal (@product1.price * 2) + (@product2.price), result[:cart].subtotal

    assert_equal 2, result[:cart].cart_items.count
  end

  test 'fail to add product with insufficient stock' do
    result = perform(
      product_id: @product3.id,
      quantity: 1
    ) 

    assert_equal 1, result[:user_errors].count
    assert_equal 0, result[:cart].cart_items.count
  end

  test 'fail to update product quantity exceeding stock' do
    result = perform(
      product_id: @product1.id,
      quantity: 3
    ) 

    assert_equal 0, result[:user_errors].count
    assert_equal 1, result[:cart].cart_items.count
    assert_equal 3, result[:cart].cart_items.first.quantity

    # exceeds inventory_count for product1
    result = perform(
      product_id: @product1.id,
      quantity: 3
    )

    assert_equal 1, result[:user_errors].count
    assert_equal 1, result[:cart].cart_items.count
    assert_equal 3, result[:cart].cart_items.first.quantity
  end
end