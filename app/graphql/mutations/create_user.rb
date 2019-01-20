class Mutations::CreateUser < Mutations::BaseMutation
  argument :name, String, required: true
  argument :auth_provider, Types::AuthProviderEmailInput, required: true

  type Types::UserType

  def resolve(name:, auth_provider:)
    User.create!(
      name: name,
      email: auth_provider[:email],
      password: auth_provider[:password]
    )
  end
end
