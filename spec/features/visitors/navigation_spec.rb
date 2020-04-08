require 'rails_helper'

RSpec.describe 'As a visitor' do
  it 'can not access merchant, admin, or profile' do

    visit "/user/profile"
    expect(page).to have_content("The page you were looking for doesn't exist.")

    visit "/merchant/dashboard"
    expect(page).to have_content("The page you were looking for doesn't exist.")

    visit "/admin/dashboard"
    expect(page).to have_content("The page you were looking for doesn't exist.")
  end
end
