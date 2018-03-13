describe Fastlane::Actions::IconVersioningAction do
  let(:action) { Fastlane::Actions::IconVersioningAction }
  let(:action_helper) { Fastlane::Helper::IconVersioningHelper }
  let(:configuration) { FastlaneCore::Configuration }

  describe '#run' do
    let(:original_appiconset_path) { './spec/fixtures/Valid.appiconset' }

    before(:each) do
      versioned_appiconset_path = action_helper.get_versioned_path(original_appiconset_path)

      FileUtils.remove_entry(versioned_appiconset_path, force: true)
    end

    it 'versions the icons in the appiconset directory' do
      options = {
        appiconset_path: original_appiconset_path,
        text: 'test'
      }

      config = configuration.create(action.available_options, options)

      expect(action).to receive(:run).with(config).and_call_original

      action.run(config)

      versioned_appiconset_path = action_helper.get_versioned_path(options[:appiconset_path])

      expect(Pathname.new(versioned_appiconset_path)).to exist
    end

    it 'versions all the icons in the appiconset directory' do
      options = {
        appiconset_path: original_appiconset_path,
        text: 'test'
      }

      config = configuration.create(action.available_options, options)

      action.run(config)

      Dir.glob("#{original_appiconset_path}/*.png").each do |original_icon_path|
        versioned_icon_path = action_helper.get_versioned_path(original_icon_path)

        expect(FileUtils.identical?(original_icon_path, versioned_icon_path)).to be false
      end
    end

    it 'versions all the icons in the appiconset directory except the ignored one' do
      options = {
        appiconset_path: original_appiconset_path,
        text: 'test',
        ignored_icons_regex: /_ultra/
      }

      config = configuration.create(action.available_options, options)

      action.run(config)

      Dir.glob("#{original_appiconset_path}/*.png").each do |original_icon_path|
        versioned_icon_path = action_helper.get_versioned_path(original_icon_path)

        is_ignored = !(original_icon_path =~ options[:ignored_icons_regex]).nil?

        expect(FileUtils.identical?(original_icon_path, versioned_icon_path)).to eq(is_ignored)
      end
    end
  end
end
