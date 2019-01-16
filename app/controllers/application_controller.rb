class ApplicationController < ActionController::Base
    # may end up with stale carts w/ tons of unique users – clean up job could be created
    def current_cart
      Cart.find(session[:cart_id])
    rescue ActiveRecord::RecordNotFound
      cart = Cart.new
      session[:cart_id] = cart.id
      cart
    end
end
