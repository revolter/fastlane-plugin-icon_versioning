describe Fastlane::Actions::IconVersioningAction do
  let(:action) { Fastlane::Actions::IconVersioningAction }
  let(:action_helper) { Fastlane::Helper::VersionIconHelper }
  let(:configuration) { FastlaneCore::Configuration }

  describe '#run' do
    let(:original_appiconset_path) { './spec/fixtures/Valid.appiconset' }

    before(:each) do
      versioned_appiconset_path = action_helper.get_versioned_path(original_appiconset_path)

      FileUtils.remove_entry(versioned_appiconset_path, force: true)
    end

    it 'prints a deprecation message' do
      options = {
        appiconset_path: original_appiconset_path,
        text: 'test'
      }

      config = configuration.create(action.available_options, options)

      expect(Fastlane::UI).to receive(:important).with('This action was deprecated. Please use "version_icon" instead.')

      action.run(config)
    end
  end
end
