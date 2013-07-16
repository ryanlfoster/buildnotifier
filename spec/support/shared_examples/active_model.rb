shared_context 'active model field' do
  let(:model_class) { described_class }
  let(:model_name) { described_class.to_s.underscore.to_sym }
  let(:field) { self.class.superclass.description.sub(/^#/, '').to_sym }
end

# usage:
#
# describe User do
#   # the name must be field name prefixed with sharp (#)
#   describe '#email' do
#     it_behaves_like 'a unique field'
#   end
# end
shared_examples 'a unique field' do
  include_context 'active model field'

  let!(:model) { create(model_name) }

  it 'should be unique' do
    duplicate_model = build(model_name, field => model.send(field))
    duplicate_model.save
    duplicate_model.should be_a_new(model_class)
  end
end

shared_examples 'a case insensitive unique field' do
  include_examples 'a unique field'

  it 'should be case insensitive unique' do
    duplicate_model = build(model_name, field => model.send(field).upcase)
    duplicate_model.save
    duplicate_model.should be_a_new(model_class)
  end
end
