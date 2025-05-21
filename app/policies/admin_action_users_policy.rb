class AdminActionUsersPolicy < ApplicationPolicy
  FULL_ACCESS_ROLES = %w[superadmin policy_and_abuse].freeze

  def mass_setup?
    user_has_roles?(FULL_ACCESS_ROLES)
  end

  alias mass_action? mass_setup?
  alias mass_create? mass_setup?
end
