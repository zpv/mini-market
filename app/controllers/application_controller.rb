class ApplicationController < ActionController::Base
  def current_cart
    Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
    Cart.new
  end

  # Using secure tokens within sessions for authentication due to constraints (graphiql demo)
  # In practice, using JWT tokens would be a better approach due to better RESTFul design.
  def current_user
    return unless session[:token]

    crypt = ActiveSupport::MessageEncryptor.new(
      Rails.application.credentials.secret_key_base.byteslice(0..31)
    )

    token = crypt.decrypt_and_verify session[:token]
    user_id = token.gsub('user-id:', '').to_i
    User.find_by id: user_id
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    nil
  end
end
