describe Fastlane::Actions::IconVersioningAction do
  let(:action) { Fastlane::Actions::IconVersioningAction }
  let(:configuration) { FastlaneCore::Configuration }

  context 'when passing the appiconset path' do
    it 'sets the value when it is valid' do
      options = { appiconset_path: File.expand_path('./spec/fixtures/Correct.appiconset') }

      config = configuration.create(action.available_options, options)

      expect(config[:appiconset_path]).to eq(options[:appiconset_path])
    end

    it 'raises an exception when it isn\'t found' do
      options = { appiconset_path: File.expand_path('./spec/fixtures/Missing') }

      expect do
        configuration.create(action.available_options, options)
      end.to raise_error('Appiconset not found')
    end

    it 'raises an exception when it isn\'t a directory' do
      options = { appiconset_path: File.expand_path('./spec/fixtures/File.appiconset') }

      expect do
        configuration.create(action.available_options, options)
      end.to raise_error('Appiconset is not a directory')
    end

    it 'raises an exception when it isn\'t named correctly' do
      options = { appiconset_path: File.expand_path('./spec/fixtures/Name.incorrect') }

      expect do
        configuration.create(action.available_options, options)
      end.to raise_error('Appiconset does not end with .appiconset')
    end
  end

  context 'when passing the band height percentage' do
    it 'sets the value when it is valid' do
      options = { band_height_percentage: 0.42 }

      config = configuration.create(action.available_options, options)

      expect(config[:band_height_percentage]).to eq(options[:band_height_percentage])
    end

    it 'raises an exception when it is less than 0' do
      options = { band_height_percentage: -1.3 }

      expect do
        configuration.create(action.available_options, options)
      end.to raise_error('Band height percentage is less than 0')
    end

    it 'raises an exception when it is greater than 1' do
      options = { band_height_percentage: 2.3 }

      expect do
        configuration.create(action.available_options, options)
      end.to raise_error('Band height percentage is greater than 1')
    end
  end

  context 'when passing the band blur radius percentage' do
    it 'sets the value when it is valid' do
      options = { band_blur_radius_percentage: 5.5 }

      config = configuration.create(action.available_options, options)

      expect(config[:band_blur_radius_percentage]).to eq(options[:band_blur_radius_percentage])
    end

    it 'raises an exception when it is less than 0' do
      options = { band_blur_radius_percentage: -3.0 }

      expect do
        configuration.create(action.available_options, options)
      end.to raise_error('Band blur radius percentage is less than 0')
    end
  end

  context 'when passing the band blur sigma percentage' do
    it 'sets the value when it is valid' do
      options = { band_blur_sigma_percentage: 0.5 }

      config = configuration.create(action.available_options, options)

      expect(config[:band_blur_sigma_percentage]).to eq(options[:band_blur_sigma_percentage])
    end

    it 'raises an exception when it is less than 0' do
      options = { band_blur_sigma_percentage: -2.5 }

      expect do
        configuration.create(action.available_options, options)
      end.to raise_error('Band blur sigma percentage is less than 0')
    end

    it 'raises an exception when it is greater than 65355' do
      options = { band_blur_sigma_percentage: 65356.0 }

      expect do
        configuration.create(action.available_options, options)
      end.to raise_error('Band blur sigma percentage is greater than 65355')
    end
  end
end
