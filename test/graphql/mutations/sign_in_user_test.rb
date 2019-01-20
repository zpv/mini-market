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
      email: @user.email,
      password: @user.password
    )

    assert result.present?
    assert result.token.present?
    assert_equal result.user, @user
  end

  test 'bad email' do
    assert_nil perform(
      email: 'wrong',
      password: @user.password
    )
  end

  test 'bad password' do
    assert_nil perform(
      email: @user.email,
      password: 'wrong'
    )
  end
end
