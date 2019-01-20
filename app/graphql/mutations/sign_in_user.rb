module Mutations
  class SignInUser < BaseMutation
    argument :email, String, required: true
    argument :password, String, required: true

    field :token, String, null: false
    field :user, Types::UserType, null: false

    def resolve(email:, password:)
      user = User.find_by(email: email)

      # ensure user is found and is properly authenticated
      return unless user
      return unless user.authenticate(password)

      crypt = ActiveSupport::MessageEncryptor.new(
        Rails.application.credentials.secret_key_base.byteslice(0..31)
      )

      token = crypt.encrypt_and_sign("user-id:#{user.id}")
      context[:session][:token] = token

      OpenStruct.new(
        user: user,
        token: token
      )
    end
  end
end
