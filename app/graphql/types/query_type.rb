module Types
  class QueryType < Types::BaseObject
    field :products, [ProductType], null: true do
      description 'Display a list of products'
      argument :only_available, Boolean, required: false, default_value: false
    end

    def products(only_available:)
      if only_available
        Product.where("inventory_count > 0")
      else
        Product.all
      end
    end

    field :product, ProductType, null: false do
      argument :id, Int, required: false
    end

    def product(id:)
      Product.find(id)
    end
  end
end
