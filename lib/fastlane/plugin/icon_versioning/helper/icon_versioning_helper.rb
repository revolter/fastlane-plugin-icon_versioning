module Fastlane
  module Helper
    class IconVersioningHelper
      # class methods that you define here become available in your action
      # as `Helper::IconVersioningHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the icon_versioning plugin helper!")
      end
    end
  end
end
