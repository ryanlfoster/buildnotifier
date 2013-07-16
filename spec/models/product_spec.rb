require 'spec_helper'

describe Product do
  # fields
  it { should have_field(:name) }
  it { should have_field(:identification) }
  it { should have_field(:description) }

  # associations
  it { should have_many(:releases).with_dependent(:destroy) }
  it { should have_many(:approval_steps).with_dependent(:destroy) }
  it { should have_many(:groups).with_dependent(:destroy) }

  # validations
  it { should validate_uniqueness_of :identification }
end
