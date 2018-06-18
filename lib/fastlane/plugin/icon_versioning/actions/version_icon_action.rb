require 'fastlane/action'
require_relative '../helper/version_icon_helper'

module Fastlane
  module Actions
    class VersionIconAction < Action
      def self.run(params)
        version_icon_helper = Helper::VersionIconHelper.new(params)

        return version_icon_helper.run()
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
            env_name: 'VERSION_ICON_APPICONSET_PATH',
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
            env_name: 'VERSION_ICON_TEXT',
            description: 'The text to overlay over the icon images',
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :text_color,
            env_name: 'VERSION_ICON_TEXT_COLOR',
            description: 'Optional color for the text overlaying the icon images. It must be a color name (`red`) or a set of numbers as described here: https://www.imagemagick.org/script/color.php',
            default_value: 'white',
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :text_margins_percentages,
            env_name: 'VERSION_ICON_TEXT_MARGINS_PERCENTAGES',
            description: 'Optional percentages of the text margins relative to the image\'s size. The array must have all four margins: `text_margins_percentages: [top, right, bottom, left]`, two values: `text_margins_percentages: [vertical, horizontal]` or one value for all of them: `text_margins: [all]`',
            default_value: [0.06],
            verify_block: proc do |value|
              UI.user_error!('The number of margins is not equal to 1, 2 or 4') unless value.length == 1 || value.length == 2 || value.length == 4
              UI.user_error!('At least one margin percentage is less than 0') if value.any? { |percentage| percentage < 0 }
              UI.user_error!('At least one margin percentage is greater than 1') if value.any? { |percentage| percentage > 1 }
            end,
            optional: true,
            type: Array
          ),
          FastlaneCore::ConfigItem.new(
            key: :band_height_percentage,
            env_name: 'VERSION_ICON_BAND_HEIGHT_PERCENTAGE',
            description: 'Optional percentage of the text band height relative to the image\'s height. A float number between 0 and 1',
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
            env_name: 'VERSION_ICON_BAND_BLUR_RADIUS_PERCENTAGE',
            description: 'Optional blur radius percentage of the text band. The default value behaves like an automatic setting which produces the best results. More details: http://www.imagemagick.org/Usage/blur/#blur_args',
            default_value: 0,
            verify_block: proc do |value|
              UI.user_error!('Band blur radius percentage is less than 0') if value < 0
            end,
            optional: true,
            type: Float
          ),
          FastlaneCore::ConfigItem.new(
            key: :band_blur_sigma_percentage,
            env_name: 'VERSION_ICON_BAND_BLUR_SIGMA_PERCENTAGE',
            description: 'Optional blur sigma percentage of the text band. More details: http://www.imagemagick.org/Usage/blur/#blur_args',
            default_value: 0.05,
            verify_block: proc do |value|
              UI.user_error!('Band blur sigma percentage is less than 0') if value < 0
              UI.user_error!('Band blur sigma percentage is greater than 65355') if value > 65_355
            end,
            optional: true,
            type: Float
          ),
          FastlaneCore::ConfigItem.new(
            key: :ignored_icons_regex,
            env_name: 'VERSION_ICON_IGNORED_ICONS_REGEX',
            description: 'Optional regex that causes the icons that match against it not to be versioned',
            optional: true,
            type: Regexp
          )
        ]
      end

      def self.is_supported?(platform)
        [:ios].include?(platform)
      end
    end
  end
end
