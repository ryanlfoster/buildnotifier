require 'spec_helper'

describe Group do
  # fields
  it { should have_field :name }
  it { should have_field(:permissions).of_type(Array).with_default_value_of([:view_release]) }

  # associations
  it { should have_and_belong_to_many :users }
  it { should belong_to :product }
  it { should have_many(:approval_steps).with_dependent(:destroy) }

  # validations
  it { should validate_presence_of :name }
  it { should validate_uniqueness_of :name }
end
