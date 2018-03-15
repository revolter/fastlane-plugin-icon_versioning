require 'fastlane/action'
require_relative 'version_icon_action'

module Fastlane
  module Actions
    class IconVersioningAction < VersionIconAction
      def self.run(params)
        UI.important('This action was deprecated. Please use "version_icon" instead.')

        return super
      end

      def self.category
        :deprecated
      end

      def self.deprecated_notes
        'Please use the `version_icon` action instead.'
      end
    end
  end
end
