require 'fastlane/action'
require_relative '../helper/icon_versioning_helper'

module Fastlane
  module Actions
    class IconVersioningAction < Action
      def self.run(params)
        Helper::IconVersioningHelper.run(params)
      end

      def self.description
        'Overlay build information on top of your app icon'
      end

      def self.authors
        ['Iulian Onofrei']
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
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :band_height_percentage,
            env_name: 'ICON_VERSIONING_BAND_HEIGHT_PERCENTAGE',
            description: 'The percentage of the text band height relative to the image\'s height. A float number between 0 and 1',
            default_value: 0.5,
            verify_block: proc do |value|
              UI.user_error!('Percentage is less than 0') if value < 0
              UI.user_error!('Percentage is greater than 1') if value > 1
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
