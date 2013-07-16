require 'spec_helper'

describe PasswordReset do
  # fields
  it { should have_field(:code) }
  it { should have_field(:expiration).of_type(DateTime) }

  # associations
  it { should belong_to :user }
end
