require 'spec_helper'

describe Release do
  let(:user) { create(:user) }
	let(:release) { FactoryGirl.create(:release, creator: user) }
	# fields
	it { should have_field(:name) }
	it { should have_field(:version) }
	it { should have_field(:notes) }
	it { should have_field(:identification) }
	it { should have_field(:overall_status) }

	# associations
	it { should belong_to(:product) }
	it { should belong_to(:creator) }
	it { should have_many(:approval_statuses).with_dependent(:destroy) }

	# validations
	it { should validate_presence_of :name }
  it { should validate_presence_of :identification }	

	describe ".descriptive_name" do
		it "should be right" do
		  release.descriptive_name.should == "#{release.name} v#{release.version}"
	  end
	end
end
