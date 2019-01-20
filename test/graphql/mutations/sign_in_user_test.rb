require 'test_helper'

class Mutations::SignInUserTest < ActiveSupport::TestCase
  def perform(args)
    Mutations::SignInUser.new(object: nil, context: { session: {} }).resolve(
      **args
    )
  end

  setup do
    @user = User.create! name: 'test', email: 'test@email.com', password: 'test'
  end

  test 'creates a token' do
    result = perform(
      auth_provider: {
        email: @user.email,
        password: @user.password
      }
    )

    assert result.present?
    assert result.token.present?
    assert_equal result.user, @user
  end

  # Should fail to create record with empty email/password
  test 'wrong email' do
    assert_nil perform(auth_provider: {
                         email: 'wrong'
                       })
  end

  test 'wrong password' do
    assert_nil perform(auth_provider: {
                         email: @user.email,
                         password: 'wrong'
                       })
  end
end
