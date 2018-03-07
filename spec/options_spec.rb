describe Fastlane::Actions::IconVersioningAction do
  let(:action) { Fastlane::Actions::IconVersioningAction }
  let(:configuration) { FastlaneCore::Configuration }

  context 'when passing the appiconset path' do
    it 'sets the appiconset path when valid' do
      options = { appiconset_path: File.expand_path('./spec/fixtures/Correct.appiconset') }

      config = configuration.create(action.available_options, options)

      expect(config[:appiconset_path]).to eq(options[:appiconset_path])
    end

    it 'raises an exception when the appiconset isn\'t found' do
      expect do
        options = { appiconset_path: File.expand_path('./spec/fixtures/Missing') }

        configuration.create(action.available_options, options)
      end.to raise_error('Appiconset not found')
    end

    it 'raises an exception when the appiconset isn\'t a folder' do
      expect do
        options = { appiconset_path: File.expand_path('./spec/fixtures/File.appiconset') }

        configuration.create(action.available_options, options)
      end.to raise_error('Appiconset is not a directory')
    end

    it 'raises an exception when the appiconset isn\'t named correctly' do
      expect do
        options = { appiconset_path: File.expand_path('./spec/fixtures/Name.incorrect') }

        configuration.create(action.available_options, options)
      end.to raise_error('Appiconset does not end with .appiconset')
    end
  end

  context 'when passing the text' do
    it 'sets the text when valid' do
      options = { text: 'test' }

      config = configuration.create(action.available_options, options)

      expect(config[:text]).to eq(options[:text])
    end

    it 'doesn\'t set the text when null' do
      options = {}

      config = configuration.create(action.available_options, options)

      expect(config[:text]).to be_nil
    end
  end
end
