require 'spec_helper'

describe WebReleasesController do
  before do
    login!
  end

  describe "GET 'new'" do
    before do
      get :new
    end
    it { should respond_with(:success) }
  end
end
