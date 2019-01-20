require 'test_helper'

class Mutations::CreateUserTest < ActiveSupport::TestCase
  def perform(args)
    Mutations::CreateUser.new(object: nil, context: nil).resolve(
      **args
    )
  end

  test 'success' do
    user = perform(
      name: 'Test User',
      auth_provider: {
        email: 'email@example.com',
        password: 'hello'
      }
    )

    assert user.persisted?
    assert_equal user.name, 'Test User'
    assert_equal user.email, 'email@example.com'
  end

  # Should fail to create record with empty email/password
  test 'failure' do
    assert_raises ActiveRecord::RecordInvalid do
      perform(name: '',
              auth_provider: {
                email: '',
                password: ''
              })
    end
  end
end
