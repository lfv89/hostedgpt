require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase

  setup do
    @user = users(:keith)
    visit root_url
  end

  test "the new user form reveals more fields when password is focused and those fields stay" do
    click_text "Sign up", match: :first

    assert_visible "#person_email"
    assert_visible "#person_personable_attributes_password"

    assert_hidden "#person_personable_attributes_name"

    fill_in "Email", with: "email@email.com"
    fill_in "Password", with: "secret"

    sleep 0.1

    assert_visible "#person_personable_attributes_name"

    fill_in "Email", with: "changed@email.com"
    fill_in "Password", with: "secret" # this triggers a second focus event

    sleep 0.1

    assert_visible "#person_personable_attributes_name"
  end

  test "should display errors if fields are left blank" do
    click_text "Sign up", match: :first
    fill_in "Email", with: "tester@test.com"
    click_text "Sign Up"

    assert_text "can't be blank"
  end

  test "should hide the Sign Up link if the registration feature is disabled" do
    stub_features(registration: false) do
      visit root_url
      assert_no_text 'Sign up'
    end
  end

  test "should NOT display a Google button when the feature is DISABLED" do
    stub_features(google_authentication: false) do
      visit register_url
      assert_no_text "Sign Up with Google"
    end
  end

  test "should SHOW the Google button when the feature is ENABLED" do
    stub_features(google_authentication: true) do
      visit register_url
      assert_text "Sign Up with Google"
    end
  end

  test "should create a new user" do
    click_text "Sign up", match: :first

    fill_in "Email", with: "tester@test.com"
    fill_in "Password", with: "secret"
    fill_in "Name", with: "John Doe"

    click_text "Sign Up"

    sleep 0.3
    assert_current_path new_assistant_message_path(Person.ordered.last.user.assistants.ordered.first)
  end

  test "should login as an existing user" do
    fill_in "Email address", with: @user.person.email
    fill_in "Password", with: "secret"
    click_text "Log In"

    sleep 0.3
    assert_current_path new_assistant_message_path(@user.assistants.ordered.first)
  end
end
