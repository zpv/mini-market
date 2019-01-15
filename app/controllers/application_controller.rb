class ApplicationController < ActionController::Base
    # may end up with stale carts w/ tons of unique users – clean up job could be created
    def current_cart
      Cart.find(session[:cart_id])
    rescue ActiveRecord::RecordNotFound
      Cart.new
    end
end
