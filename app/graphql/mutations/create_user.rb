module Mutations
  class CreateUser < BaseMutation
    description 'Sign up for a new account'

    argument :name, String, required: true, description: 'Name of the account owner'
    argument :email, String, required: true, description: 'Sign-in email'
    argument :password, String, required: true, description: 'Sign-in password'

    field :user, Types::UserType, null: true
    field :user_errors, [Types::UserError], null: false

    def resolve(name:, email:, password:)
      {
        user: User.create!(
          name: name,
          email: email,
          password: password
        ),
        user_errors: []
      }
    rescue ActiveRecord::RecordInvalid => invalid
      { user_errors: [{
        path: [],
        message: invalid.message
      }] }
    end
  end
end
