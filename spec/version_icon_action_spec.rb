describe Fastlane::Actions::VersionIconAction do
  let(:action) { Fastlane::Actions::VersionIconAction }
  let(:action_helper) { Fastlane::Helper::VersionIconHelper }
  let(:configuration) { FastlaneCore::Configuration }

  describe '#run' do
    let(:original_appiconset_path) { './spec/fixtures/Valid.appiconset' }
    let(:versioned_appiconset_suffix) { 'Versioned' }

    before(:each) do
      versioned_appiconset_path = action_helper.get_versioned_path(original_appiconset_path, versioned_appiconset_suffix)

      FileUtils.remove_entry(versioned_appiconset_path, force: true)
    end

    it 'versions the icons in the appiconset directory' do
      options = {
        appiconset_path: original_appiconset_path,
        versioned_appiconset_suffix: versioned_appiconset_suffix,
        text: 'test'
      }

      config = configuration.create(action.available_options, options)

      expect(action).to receive(:run).with(config).and_call_original

      action.run(config)

      versioned_appiconset_path = action_helper.get_versioned_path(options[:appiconset_path], options[:versioned_appiconset_suffix])

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
        versioned_icon_path = action_helper.get_versioned_path(original_icon_path, versioned_appiconset_suffix)

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
        versioned_icon_path = action_helper.get_versioned_path(original_icon_path, versioned_appiconset_suffix)

        is_ignored = !(original_icon_path =~ options[:ignored_icons_regex]).nil?

        expect(FileUtils.identical?(original_icon_path, versioned_icon_path)).to eq(is_ignored)
      end
    end

    it 'versions all the icons except the cached one' do
      options = {
        appiconset_path: original_appiconset_path,
        text: 'test'
      }

      config = configuration.create(action.available_options, options)

      expect_any_instance_of(action_helper).to receive(:version_icon).twice.and_call_original

      action.run(config)

      expect_any_instance_of(action_helper).to_not receive(:version_icon).and_call_original

      action.run(config)
    end
  end
end
