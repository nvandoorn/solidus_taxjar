require 'spec_helper'

RSpec.feature 'Admin TaxJar Settings', js: true do
  stub_authorization!

  background do
    create :store, default: true
  end

  describe "Taxjar settings tab" do
    context "Taxjar API token is set" do
      before do
        allow(ENV).to receive(:[]).and_return("")
        allow(ENV).to receive(:[]).with("TAXJAR_API_KEY").and_return("API token")
      end

      it "shows a blank settings page" do
        visit "/admin"
        click_on "Settings"
        expect(page).to have_content("Taxes")
        click_on "Taxes"
        expect(page).to have_content("TaxJar Settings")
        click_on "TaxJar Settings"
        expect(page).not_to have_content "You must provide a TaxJar API token"
      end
    end

    context "Taxjar API token isn't set" do
      it "shows a descriptive error message" do
        visit "/admin"
        click_on "Settings"
        expect(page).to have_content("Taxes")
        click_on "Taxes"
        expect(page).to have_content("TaxJar Settings")
        click_on "TaxJar Settings"
        expect(page).to have_content "You must provide a TaxJar API token"

        expect(page).to have_link(href: "https://app.taxjar.com/api_sign_up")
        expect(page).to have_link(href: "https://support.taxjar.com/article/160-how-do-i-get-a-sales-tax-api-token")
      end
    end
  end
end
