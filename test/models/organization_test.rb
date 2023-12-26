require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase
  def setup
    @admin_user = User.create(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
    @admin_user.add_role(:admin)

    @non_admin_user = User.create(email: 'user@example.com', password: 'password', password_confirmation: 'password')
  end

  test "organization should be valid" do
    organization = Organization.new(name: "Test Org", admin_user: @admin_user)
    assert organization.valid?
  end

  test "organization should have a name" do
    organization = Organization.new(admin_user: @admin_user)
    assert_not organization.valid?
  end

  test "organization name should be unique" do
    Organization.create(name: "Existing Org", admin_user: @admin_user)
    organization = Organization.new(name: "Existing Org", admin_user: @admin_user)
    assert_not organization.valid?
  end

  test "organization should belong to an admin user" do
    organization = Organization.new(name: "Test Org", admin_user: @non_admin_user)
    assert_not organization.valid?
  end

  test "admin user should have multiple organizations" do
    Organization.create(name: "Org 1", admin_user: @admin_user)
    Organization.create(name: "Org 2", admin_user: @admin_user)
    assert_equal 2, @admin_user.organizations.count
  end
end
