module Fastlane
  module Actions
    class IconVersioningAction < Action
      def self.run(params)
        Helper::IconVersioningHelper.run(params)
      end

      def self.description
        "Overlay build information on top of your app icon"
      end

      def self.authors
        ["Iulian Onofrei"]
      end

      def self.available_options
        [
          # FastlaneCore::ConfigItem.new(key: :your_option,
          #                         env_name: "ICON_VERSIONING_YOUR_OPTION",
          #                      description: "A description of your option",
          #                         optional: false,
          #                             type: String)
        ]
      end

      def self.is_supported?(platform)
        [:ios].include?(platform)
      end
    end
  end
end
