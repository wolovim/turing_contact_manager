require 'rails_helper'
require 'capybara/rails'
require 'capybara/rspec'

describe 'the person view', type: :feature do

  let(:person) { Person.create(first_name: 'John', last_name: 'Doe') }

  describe '[Phone numbers]' do
    before(:each) do
      person.phone_numbers.create(number: "555-1234")
      person.phone_numbers.create(number: "555-5678")
      visit person_path(person)
    end

    it 'shows the phone numbers' do
      person.phone_numbers.each do |phone|
        expect(page).to have_content(phone.number)
      end
    end

    it 'has a link to add a new phone number' do
      expect(page).to have_link('Add phone number', href: new_phone_number_path(contact_id: person.id, contact_type: 'Person'))
    end

    it 'adds a new phone number' do
      page.click_link('Add phone number')
      page.fill_in('Number', with: '555-8888')
      page.click_button('Create Phone number')
      expect(current_path).to eq(person_path(person))
      expect(page).to have_content('555-8888')
    end

    it 'has links to edit phone numbers' do
      person.phone_numbers.each do |phone|
        expect(page).to have_link('edit', href: edit_phone_number_path(phone))
      end
    end

    it 'edits a phone number' do
      phone = person.phone_numbers.first
      old_number = phone.number

      first(:link, 'edit').click
      page.fill_in('Number', with: '555-9191')
      page.click_button('Update Phone number')
      expect(current_path).to eq(person_path(person))
      expect(page).to have_content('555-9191')
      expect(page).to_not have_content(old_number)
    end

    it 'has links to delete phone numbers' do
      person.phone_numbers.each do |phone|
        expect(page).to have_link('delete')
      end
    end
  end #of [Phone numbers]

  describe "[Email addresses]" do
    before(:each) do
      person.email_addresses.create(address: "abc@example.com")
      person.email_addresses.create(address: "xyz@example.com")
      visit person_path(person)
    end

    it 'has list items for each address' do
      person.email_addresses.each do |email|
        expect(page).to have_content(email.address)
      end
    end

    it 'has an add email address link' do
      expect(page).to have_link('Add email address', href: new_email_address_path(contact_id: person.id, contact_type: 'Person'))
    end

    it 'adds a new email address' do
      page.click_link('Add email address')
      page.fill_in('Address', with: 'jjj@example.com')
      page.click_button('Create Email address')
      expect(current_path).to eq(person_path(person))
      expect(page).to have_content('jjj@example.com')
    end

    it 'has links to edit email addresses' do
      person.email_addresses.each do |email|
        expect(page).to have_link('edit', href: edit_email_address_path(email))
      end
    end

    it 'edits a phone number' do
      email = person.email_addresses.first
      old_email = email.address

      first(:link, 'edit').click
      page.fill_in('Address', with: 'xx@example.com')
      page.click_button('Update Email address')
      expect(current_path).to eq(person_path(person))
      expect(page).to have_content('xx@example.com')
      expect(page).to_not have_content(old_email)
    end
  
  end #of [Email addresses]

end