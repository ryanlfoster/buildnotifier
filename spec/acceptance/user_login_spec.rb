require 'acceptance/acceptance_helper'

feature 'User login', %q{
  In order to claim the account
  As a user
  I want to login with my credentials
} do

  let(:user) { create(:user, password: 'abcd1234') }
  let(:password) { 'abcd1234' }

  scenario 'register with valid fields' do
    visit login_page

    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'abcd1234'

    click_button 'Log in'
    
    # brought to all products page
    page.current_path.should eq(homepage)
    page.should have_content('All products')

    # name is displayed on secondary nav
    within '.nav.pull-right' do
      page.should have_link(user.name)
    end
  end

  scenario 'register with wrong password' do
    visit login_page

    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'xabcd1234'

    click_button 'Log in'

    page.current_path.should eq(login_page)
    
    within '.alert.alert-error' do
      page.should have_content('Incorrect username or password.')
    end
  end
end
