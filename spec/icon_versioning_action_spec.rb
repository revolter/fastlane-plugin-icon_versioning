describe Fastlane::Actions::IconVersioningAction do
  let(:action) { Fastlane::Actions::IconVersioningAction }
  let(:action_helper) { Fastlane::Helper::IconVersioningHelper }
  let(:configuration) { FastlaneCore::Configuration }

  describe '#run' do
    it 'versions the icons in the appiconset directory' do
      options = {
        appiconset_path: './spec/fixtures/Correct.appiconset',
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
        appiconset_path: './spec/fixtures/Valid.appiconset',
        text: 'test'
      }

      config = configuration.create(action.available_options, options)

      action.run(config)

      versioned_appiconset_path = action_helper.get_versioned_path(options[:appiconset_path])

      expect(Pathname.new(versioned_appiconset_path)).to exist

      Dir.glob("#{versioned_appiconset_path}/*.png").each do |icon_path|
        original_icon_path = icon_path.gsub(/-Versioned/, '')

        expect(FileUtils.identical?(original_icon_path, icon_path)).to be false
      end
    end

    it 'versions all the icons in the appiconset directory except the ignored one' do
      options = {
        appiconset_path: './spec/fixtures/Valid.appiconset',
        text: 'test',
        ignored_icons_regex: /_ultra/
      }

      config = configuration.create(action.available_options, options)

      action.run(config)

      versioned_appiconset_path = action_helper.get_versioned_path(options[:appiconset_path])

      expect(Pathname.new(versioned_appiconset_path)).to exist

      Dir.glob("#{versioned_appiconset_path}/*.png").each do |icon_path|
        original_icon_path = icon_path.gsub(/-Versioned/, '')

        is_ignored = !(icon_path =~ options[:ignored_icons_regex]).nil?

        expect(FileUtils.identical?(original_icon_path, icon_path)).to eq(is_ignored)
      end
    end
  end
end
