require 'spec_helper'

describe Invitation do
  # fields
  it { should have_field(:code) }
  it { should have_field(:pending).with_default_value_of(true) }
  it { should have_field :message }

  # associations
  it { should belong_to :user }
end
