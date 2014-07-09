module Locations
  def go_to_dashboard
    visit '/dashboard'
    # causes selenium to wait until text appears on the page
    page.should have_content('My Dashboard')
  end

  def go_to_dashboard_files
    go_to_dashboard
    click_link('View Files')
    expect(page).to have_selector('li.active', text:"My Files")
  end

  def go_to_dashboard_collections
    go_to_dashboard_files
    click_link('My Collections')
    page.should have_content('My Collections')
  end

  def go_to_dashboard_shares
    go_to_dashboard_files
    click_link('Files Shared with Me')
    page.should have_content('Files Shared with Me')
  end

  def go_to_dashboard_highlights
    go_to_dashboard_files
    click_link('My Highlights')
    page.should have_content('My Highlights')
  end

  def go_to_user_profile
    first(".dropdown-toggle").click
    click_link "my profile"
  end

end

RSpec.configure do |config|
  config.include Locations
end
