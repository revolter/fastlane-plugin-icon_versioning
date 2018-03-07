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

  context 'when passing the band height percentage' do
    it 'sets the percentage when valid' do
      options = { band_height_percentage: 0.42 }

      config = configuration.create(action.available_options, options)

      expect(config[:band_height_percentage]).to eq(options[:band_height_percentage])
    end

    it 'raises an exception when the percentage is less than 0' do
      expect do
        options = { band_height_percentage: -1.3 }

        configuration.create(action.available_options, options)
      end.to raise_error('Percentage is less than 0')
    end

    it 'raises an exception when the percentage is greater than 1' do
      expect do
        options = { band_height_percentage: 2.3 }

        configuration.create(action.available_options, options)
      end.to raise_error('Percentage is greater than 1')
    end
  end
end
