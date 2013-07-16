require 'spec_helper'

describe ApprovalStatus do
  # fields
  it { should have_field(:reason) }
  it { should have_field(:status).of_type(Symbol).with_default_value_of(:unavailable) }
  it { should have_field(:date).of_type(DateTime) }
  it { should have_field(:position).of_type(Integer) }

  # associations
  it { should belong_to :approval_step }
  it { should belong_to :release }
  it { should belong_to :user }
  
end
