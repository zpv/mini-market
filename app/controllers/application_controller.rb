class ApplicationController < ActionController::Base
  # may end up with stale carts w/ tons of unique users – clean up job could be created
  def current_cart
    Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
    cart = Cart.new
    session[:cart_id] = cart.id
    cart
  end

  # Using secure tokens within sessions for authentication due to constraints (graphiql demo)
  # In practice, using JWT tokens would be a better approach.
  def current_user
    return unless session[:token]

    crypt = ActiveSupport::MessageEncryptor.new(Rails.application.credentials.secret_key_base.byteslice(0..31))
    token = crypt.decrypt_and_verify session[:token]
    user_id = token.gsub('user-id:', '').to_i
    User.find_by id: user_id
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    nil
  end
end
