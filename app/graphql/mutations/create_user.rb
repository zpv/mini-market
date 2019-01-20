module Mutations
  class CreateUser < BaseMutation
    argument :name, String, required: true
    argument :email, String, required: true
    argument :password, String, required: true

    type Types::UserType

    def resolve(name:, email:, password:)
      User.create!(
        name: name,
        email: email,
        password: password
      )
    end
  end
end
