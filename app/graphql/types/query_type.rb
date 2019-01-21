module Types
  class QueryType < Types::BaseObject
    field :products, [ProductType], null: true do
      description 'Display a list of products'
      argument :only_available, Boolean, required: false, default_value: false,
                                         description: 'Show only products with available inventory'
    end

    def products(only_available:)
      if only_available
        Product.where('inventory_count > 0')
      else
        Product.all
      end
    end

    field :product, ProductType, null: false do
      description 'View details for a specific product'
      argument :id, Int, required: false, description: 'Product ID to be queried'
    end

    def product(id:)
      Product.find(id)
    end

    field :cart, CartType, null: false do
      description 'View your current session\'s cart'
    end

    def cart
      context[:current_cart]
    end
  end
end
