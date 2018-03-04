require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class IconVersioningHelper
      def self.run(params)
        puts("The icon_versioning plugin is working!")
      end
    end
  end
end
