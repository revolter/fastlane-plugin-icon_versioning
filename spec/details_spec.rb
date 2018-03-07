describe Fastlane::Actions::IconVersioningAction do
  let(:action) { Fastlane::Actions::IconVersioningAction }

  it 'has a description' do
    description = action.description

    expect(description.length).to be > 0
  end

  it 'has authors' do
    authors = action.authors

    expect(authors.length).to be > 0
  end

  it 'supports ios' do
    is_supported = action.is_supported?(:ios)

    expect(is_supported).to be true
  end
end
