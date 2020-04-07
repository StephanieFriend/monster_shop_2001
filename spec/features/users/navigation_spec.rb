require 'rails_helper'

RSpec.describe 'As a default user' do
  it 'I see the same links as a visitor' do
    user = User.create({name: "Bob", street_address: "22 dog st", city: "Fort Collins",
                         state: "CO", zip_code: "80375", email_address: "bob@example.com",
                         password: "password1", password_confirmation: "password1"
                        })
    visit '/'

    click_link 'Log in'

    fill_in :email_address, with: 'bob@example.com'
    fill_in :password, with: 'password1'
    click_button 'Log in'

    expect(current_path).to eq('/user/profile')
    expect(page).to have_content("Logged in as #{user.name}")

    within 'nav' do
      expect(page).to have_no_link('Log in')
      expect(page).to have_no_link('Register')
    end

    within 'nav' do
      click_link 'All Items'
    end

    expect(current_path).to eq('/items')

    within 'nav' do
      click_link 'All Merchants'
    end

    expect(current_path).to eq('/merchants')

    within 'nav' do
      click_link "Home"
    end

    expect(current_path).to eq('/')

    within 'nav' do
      click_link "Cart"
    end

    expect(current_path).to eq('/cart')

    within 'nav' do
      click_link "Profile"
    end

    expect(current_path).to eq('user/profile')

    within 'nav' do
      click_link "Log out"
    end

    expect(current_path).to eq('user/logout')
  end
end