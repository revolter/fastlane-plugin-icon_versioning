describe Fastlane::Actions::IconVersioningAction do
  let(:action) { Fastlane::Actions::IconVersioningAction }

  it 'is deprecated' do
    category = action.category

    expect(category).to eq(:deprecated)
  end

  it 'has a deprecation notice' do
    deprecated_notes = action.deprecated_notes

    expect(deprecated_notes.length).to be > 0
  end
end
