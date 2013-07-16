require 'spec_helper'

describe SessionsController do
  describe 'routing' do
    it 'routes /login to #new' do
      get('/login').should route_to('sessions#new')
    end
    it 'routes /auth/failure to #failure' do
      get('/auth/failure').should route_to('sessions#failure')
    end
    it 'routes /auth/twitter/callback to #create' do
      get('/auth/twitter/callback').should route_to('sessions#create', provider: 'twitter')
    end
  end
end
