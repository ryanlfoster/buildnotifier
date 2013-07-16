require 'spec_helper'

describe Identity do
  describe '#email' do
    it_behaves_like 'a case insensitive unique field'
  end
end
