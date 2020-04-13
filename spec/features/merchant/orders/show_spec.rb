require 'rails_helper'

RSpec.describe 'As a merchant employee' do
  describe 'When I visit an order show page from my dashboard' do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @regina = User.create({name: "Regina",
                             street_address: "6667 Evil Ln",
                             city: "Storybrooke",
                             state: "ME",
                             zip_code: "00435",
                             email_address: "evilqueen@example.com",
                             password: "henry2004",
                             password_confirmation: "henry2004",
                             role: 1,
                             merchant_id: @meg.id
                            })

      visit '/'

      click_on 'Log in'
      fill_in :email_address, with: 'evilqueen@example.com'
      fill_in :password, with: 'henry2004'
      click_button 'Log in'

      @order_1 = Order.create({name: "Bob", address: "22 dog st", city: "Fort Collins",
                               state: "CO", zip: "80375", status: "Pending", user_id: @regina.id})
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)

      @item_order_1 =  @order_1.item_orders.create!({ item: @tire, quantity: 3, price: @tire.price })
      @item_order_2 =  @order_1.item_orders.create!({ item: @paper, quantity: 2, price: @paper.price })

    end
    it 'I see the name and address of whom created the order && only items from my merchant' do

      visit '/merchant'
      click_link "Order ##{@order_1.id}"

      expect(page).to have_content(@order_1.name)
      expect(page).to have_content(@order_1.address)
      expect(page).to have_content(@order_1.city)
      expect(page).to have_content(@order_1.state)
      expect(page).to have_content(@order_1.zip)

      expect(page).to have_link(@tire.name)
      expect(page).to have_content(@tire.image)
      expect(page).to have_content("Price: #{@tire.price}")
      expect(page).to have_content("Quantity: #{@item_order_1.quantity}")

      expect(page).to have_no_link(@paper.name)
      expect(page).to have_no_content(@paper.image)
      expect(page).to have_no_content("Price: #{@paper.price}")
      expect(page).to have_no_content("Quantity: #{@item_order_2.quantity}")
    end
  end
end