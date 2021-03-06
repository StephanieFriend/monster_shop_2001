require 'rails_helper'

RSpec.describe 'As an admin user I can visit the user index page' do
  it "I can see all users in the system with name, date they registered, and type of user" do
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @brian = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203, active?:false)

    @bob = User.create({name: "Bob",
                       street_address: "22 dog st",
                       city: "Fort Collins",
                       state: "CO",
                       zip_code: "80375",
                       email_address: "user@example.com",
                       password: "password_regular",
                       password_confirmation: "password_regular",
                       role: 0
                        })
    @regina = User.create({name: "Regina",
                           street_address: "6667 Evil Ln",
                           city: "Storybrooke",
                           state: "ME",
                           zip_code: "00435",
                           email_address: "merchant@example.com",
                           password: "password_merchant",
                           password_confirmation: "password_merchant",
                           role: 1,
                           merchant_id: @meg.id
                          })
    @bert = User.create({name: "Bert",
                          street_address: "123 Sesame St.",
                          city: "New York City",
                          state: "NY",
                          zip_code: "10001",
                          email_address: "admin@example.com",
                          password: "password_admin",
                          password_confirmation: "password_admin",
                          role: 2
                         })


    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @pull_toy = @meg.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    @dog_bone = @meg.items.create(name: "Dog Bone", description: "They'll love it!", price: 20, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

    visit '/'

    click_on 'Log in'
    fill_in :email_address, with: 'admin@example.com'
    fill_in :password, with: 'password_admin'
    click_button 'Log in'

    within 'nav' do
      click_link 'Users'
    end

    expect(current_path).to eq('/admin/users')

    within("#user-#{@bob.id}") do
      expect(page).to have_link(@bob.name)
      expect(page).to have_content(@bob.created_at)
      expect(page).to have_content(@bob.role)
      click_link @bob.name
    end

    expect(current_path).to eq("/admin/users/#{@bob.id}")
    within 'nav' do
      click_link 'Users'
    end

    within("#user-#{@regina.id}") do
      expect(page).to have_link(@regina.name)
      expect(page).to have_content(@regina.created_at)
      expect(page).to have_content(@regina.role)
      click_link @regina.name
    end

    expect(current_path).to eq("/admin/users/#{@regina.id}")
    within 'nav' do
      click_link 'Users'
    end

    within("#user-#{@bert.id}") do
      expect(page).to have_link(@bert.name)
      expect(page).to have_content(@bert.created_at)
      expect(page).to have_content(@bert.role)
      click_link @bert.name
    end

    expect(current_path).to eq("/admin/users/#{@bert.id}")
    within 'nav' do
      click_link 'Users'
    end
  end
end
