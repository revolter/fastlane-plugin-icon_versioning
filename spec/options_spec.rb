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
      options = { appiconset_path: File.expand_path('./spec/fixtures/Missing') }

      expect do
        configuration.create(action.available_options, options)
      end.to raise_error('Appiconset not found')
    end

    it 'raises an exception when the appiconset isn\'t a folder' do
      options = { appiconset_path: File.expand_path('./spec/fixtures/File.appiconset') }

      expect do
        configuration.create(action.available_options, options)
      end.to raise_error('Appiconset is not a directory')
    end

    it 'raises an exception when the appiconset isn\'t named correctly' do
      options = { appiconset_path: File.expand_path('./spec/fixtures/Name.incorrect') }

      expect do
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
  end

  context 'when passing the band height percentage' do
    it 'sets the percentage when valid' do
      options = { band_height_percentage: 0.42 }

      config = configuration.create(action.available_options, options)

      expect(config[:band_height_percentage]).to eq(options[:band_height_percentage])
    end

    it 'raises an exception when the percentage is less than 0' do
      options = { band_height_percentage: -1.3 }

      expect do
        configuration.create(action.available_options, options)
      end.to raise_error('Percentage is less than 0')
    end

    it 'raises an exception when the percentage is greater than 1' do
      options = { band_height_percentage: 2.3 }

      expect do
        configuration.create(action.available_options, options)
      end.to raise_error('Percentage is greater than 1')
    end
  end
end
