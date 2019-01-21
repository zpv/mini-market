module Mutations
  class AuthenticatedMutation < GraphQL::Schema::Mutation
    def authorized?
      return true if context[:current_user].present?

      {
        user_errors: [{
          message: 'You must be logged in to perform this action.',
          path: []
        }]
      }
    end
  end
end
