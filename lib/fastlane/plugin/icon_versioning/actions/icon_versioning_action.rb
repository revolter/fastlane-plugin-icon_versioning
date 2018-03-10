require 'fastlane/action'
require_relative '../helper/icon_versioning_helper'

module Fastlane
  module Actions
    class IconVersioningAction < Action
      def self.run(params)
        Helper::IconVersioningHelper.run(params)
      end

      def self.description
        'Overlay build information on top of your app icon. Based on original work by Krzysztof Zabłocki (https://github.com/krzysztofzablocki/Bootstrap).'
      end

      def self.authors
        ['Iulian Onofrei', 'Krzysztof Zabłocki']
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :appiconset_path,
            env_name: 'ICON_VERSIONING_APPICONSET_PATH',
            description: 'The path to the `.appiconset` directory containing the icon images',
            verify_block: proc do |value|
              path = File.expand_path(value.to_s)

              UI.user_error!('Appiconset not found') unless File.exist?(path)
              UI.user_error!('Appiconset is not a directory') unless File.directory?(path)
              UI.user_error!('Appiconset does not end with .appiconset') unless path.end_with?('.appiconset')
            end,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :text,
            env_name: 'ICON_VERSIONING_TEXT',
            description: 'The text to overlay over the icon images',
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :band_height_percentage,
            env_name: 'ICON_VERSIONING_BAND_HEIGHT_PERCENTAGE',
            description: 'The percentage of the text band height relative to the image\'s height. A float number between 0 and 1',
            default_value: 0.5,
            verify_block: proc do |value|
              UI.user_error!('Band height percentage is less than 0') if value < 0
              UI.user_error!('Band height percentage is greater than 1') if value > 1
            end,
            optional: true,
            type: Float
          ),
          FastlaneCore::ConfigItem.new(
            key: :band_blur_radius_percentage,
            env_name: 'ICON_VERSIONING_BAND_BLUR_RADIUS_PERCENTAGE',
            description: 'The blur radius percentage of the text band. The default value behaves like an automatic setting which produces the best results. More details: http://www.imagemagick.org/Usage/blur/#blur_args',
            default_value: 0,
            verify_block: proc do |value|
              UI.user_error!('Band blur radius percentage is less than 0') if value < 0
            end,
            optional: true,
            type: Float
          )
        ]
      end

      def self.is_supported?(platform)
        [:ios].include?(platform)
      end
    end
  end
end
