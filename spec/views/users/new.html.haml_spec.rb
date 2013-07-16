require 'spec_helper'

describe "users/new.html.haml" do
  let(:identity) { build(:identity) }
  before { assign(:identity, identity) }

  it "renders fields in <form>" do
    render
    page.should have_css('form')
  end

  it "posts form to /auth/identity/register" do
    render
    page.should have_css('form[action="/auth/identity/register"]')
  end
end
