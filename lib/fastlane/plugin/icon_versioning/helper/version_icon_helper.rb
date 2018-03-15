require 'digest'
require 'fileutils'
require 'mini_magick'
require 'yaml'

require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?('UI')

  module Helper
    class VersionIconHelper
      CACHE_FILE_NAME = 'cache.yml'.freeze

      attr_accessor :appiconset_path
      attr_accessor :text

      attr_accessor :band_height_percentage
      attr_accessor :band_blur_radius_percentage
      attr_accessor :band_blur_sigma_percentage

      attr_accessor :ignored_icons_regex

      def initialize(params)
        self.appiconset_path = File.expand_path(params[:appiconset_path])
        self.text = params[:text]

        self.band_height_percentage = params[:band_height_percentage]
        self.band_blur_radius_percentage = params[:band_blur_radius_percentage]
        self.band_blur_sigma_percentage = params[:band_blur_sigma_percentage]

        self.ignored_icons_regex = params[:ignored_icons_regex]
      end

      def run()
        versioned_appiconset_path = self.class.get_versioned_path(self.appiconset_path)

        Dir.mkdir(versioned_appiconset_path) unless Dir.exist?(versioned_appiconset_path)

        cache_file_path = File.join(versioned_appiconset_path, CACHE_FILE_NAME)

        if File.exist?(cache_file_path)
          cache = YAML.load_file(cache_file_path)
        else
          cache = {}
        end

        Dir.glob("#{self.appiconset_path}/*.png").each do |original_icon_path|
          versioned_icon_path = self.class.get_versioned_path(original_icon_path)

          text_sha = Digest::SHA2.hexdigest(self.text)

          unless cache[original_icon_path].nil?
            if File.exist?(versioned_icon_path)
              versioned_icon_sha = Digest::SHA2.file(versioned_icon_path).hexdigest

              cached_text_sha = cache[original_icon_path][:text]
              cached_icon_sha = cache[original_icon_path][:icon]

              next if text_sha == cached_text_sha && versioned_icon_sha == cached_icon_sha
            end
          end

          if self.ignored_icons_regex && !(original_icon_path =~ self.ignored_icons_regex).nil?
            FileUtils.copy(original_icon_path, versioned_icon_path)
          else
            version_icon(original_icon_path, versioned_icon_path)
          end

          cache[original_icon_path] = {}

          cache[original_icon_path][:text] = text_sha
          cache[original_icon_path][:icon] = Digest::SHA2.file(versioned_icon_path).hexdigest
        end

        File.open(cache_file_path, 'w') { |file| file.write(cache.to_yaml) }
      end

      def self.get_versioned_path(path)
        return path.gsub(/([^.]+)(\.appiconset)/, '\1-Versioned\2')
      end

      private

      def version_icon(original_icon_path, versioned_icon_path)
        image = MiniMagick::Image.open(original_icon_path)

        width = image[:width]
        height = image[:height]

        band_height = height * self.band_height_percentage
        band_blur_radius = width * self.band_blur_radius_percentage
        band_blur_sigma = width * self.band_blur_sigma_percentage

        band_top_position = height - band_height

        blurred_icon_path = suffix(versioned_icon_path, 'blurred')
        mask_icon_path = suffix(versioned_icon_path, 'mask')
        text_base_icon_path = suffix(versioned_icon_path, 'text_base')
        text_icon_path = suffix(versioned_icon_path, 'text')
        temp_icon_path = suffix(versioned_icon_path, 'temp')

        MiniMagick::Tool::Convert.new do |convert|
          convert << original_icon_path
          convert << '-blur' << "#{band_blur_radius}x#{band_blur_sigma}"
          convert << blurred_icon_path
        end

        MiniMagick::Tool::Convert.new do |convert|
          convert << blurred_icon_path
          convert << '-gamma' << '0'
          convert << '-fill' << 'white'
          convert << '-draw' << "rectangle 0, #{band_top_position}, #{width}, #{height}"
          convert << mask_icon_path
        end

        MiniMagick::Tool::Convert.new do |convert|
          convert << '-size' << "#{width}x#{band_height}"
          convert << 'xc:none'
          convert << '-fill' << 'rgba(0, 0, 0, 0.2)'
          convert << '-draw' << "rectangle 0, 0, #{width}, #{band_height}"
          convert << text_base_icon_path
        end

        MiniMagick::Tool::Convert.new do |convert|
          convert << '-background' << 'none'
          convert << '-size' << "#{width}x#{band_height}"
          convert << '-fill' << 'white'
          convert << '-gravity' << 'center'
          # using label instead of caption prevents wrapping long lines
          convert << "label:#{self.text}"
          convert << text_icon_path
        end

        MiniMagick::Tool::Convert.new do |convert|
          convert << original_icon_path
          convert << blurred_icon_path
          convert << mask_icon_path
          convert << '-composite'
          convert << temp_icon_path
        end

        File.delete(blurred_icon_path, mask_icon_path)

        MiniMagick::Tool::Convert.new do |convert|
          convert << temp_icon_path
          convert << text_base_icon_path
          convert << '-geometry' << "+0+#{band_top_position}"
          convert << '-composite'
          convert << text_icon_path
          convert << '-geometry' << "+0+#{band_top_position}"
          convert << '-composite'
          convert << versioned_icon_path
        end

        File.delete(text_base_icon_path, text_icon_path, temp_icon_path)
      end

      def suffix(path, text)
        extension = File.extname(path)

        return path.gsub(extension, "_#{text}#{extension}")
      end
    end
  end
end
