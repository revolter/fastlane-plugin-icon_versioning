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
      CONTENTS_JSON_FILE_NAME = 'Contents.json'.freeze

      def initialize(params)
        @appiconset_path = File.expand_path(params[:appiconset_path])
        @text = params[:text]
        @text_color = params[:text_color]
        @color = params[:text_color]

        text_margins_percentages = params[:text_margins_percentages]

        text_margins_percentages *= 4 if text_margins_percentages.length == 1
        text_margins_percentages *= 2 if text_margins_percentages.length == 2

        @text_top_margin_percentage = text_margins_percentages[0]
        @text_right_margin_percentage = text_margins_percentages[1]
        @text_bottom_margin_percentage = text_margins_percentages[2]
        @text_left_margin_percentage = text_margins_percentages[3]

        @band_height_percentage = params[:band_height_percentage]
        @band_blur_radius_percentage = params[:band_blur_radius_percentage]
        @band_blur_sigma_percentage = params[:band_blur_sigma_percentage]

        @ignored_icons_regex = params[:ignored_icons_regex]
      end

      def run()
        versioned_appiconset_path = self.class.get_versioned_path(@appiconset_path)

        Dir.mkdir(versioned_appiconset_path) unless Dir.exist?(versioned_appiconset_path)

        cache_file_path = File.join(versioned_appiconset_path, CACHE_FILE_NAME)

        if File.exist?(cache_file_path)
          cache = YAML.load_file(cache_file_path)
        else
          cache = {}
        end

        FileUtils.copy("#{@appiconset_path}/#{CONTENTS_JSON_FILE_NAME}", "#{versioned_appiconset_path}/#{CONTENTS_JSON_FILE_NAME}")

        Dir.glob("#{@appiconset_path}/*.png").each do |original_icon_path|
          versioned_icon_path = self.class.get_versioned_path(original_icon_path)

          text_sha = Digest::SHA2.hexdigest(@text)

          unless cache[original_icon_path].nil?
            if File.exist?(versioned_icon_path)
              versioned_icon_sha = Digest::SHA2.file(versioned_icon_path).hexdigest

              cached_text_sha = cache[original_icon_path][:text]
              cached_icon_sha = cache[original_icon_path][:icon]

              next if text_sha == cached_text_sha && versioned_icon_sha == cached_icon_sha
            end
          end

          if @ignored_icons_regex && !(original_icon_path =~ @ignored_icons_regex).nil?
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

        image_width = image[:width]
        image_height = image[:height]

        band_height = image_height * @band_height_percentage
        band_blur_radius = image_width * @band_blur_radius_percentage
        band_blur_sigma = image_width * @band_blur_sigma_percentage

        band_top_position = image_height - band_height

        text_top_margin = image_height * @text_top_margin_percentage
        text_right_margin = image_width * @text_right_margin_percentage
        text_bottom_margin = image_height * @text_bottom_margin_percentage
        text_left_margin = image_width * @text_left_margin_percentage

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
          convert << '-draw' << "rectangle 0, #{band_top_position}, #{image_width}, #{image_height}"
          convert << mask_icon_path
        end

        MiniMagick::Tool::Convert.new do |convert|
          convert << '-size' << "#{image_width}x#{band_height}"
          convert << 'xc:none'
          convert << '-fill' << 'rgba(0, 0, 0, 0.2)'
          convert << '-draw' << "rectangle 0, 0, #{image_width}, #{band_height}"
          convert << text_base_icon_path
        end

        MiniMagick::Tool::Convert.new do |convert|
          convert << '-background' << 'none'
          convert << '-size' << "#{image_width - (text_left_margin + text_right_margin)}x#{band_height - (text_top_margin + text_bottom_margin)}"
          convert << '-fill' << @text_color
          convert << '-fill' << @color
          convert << '-gravity' << 'center'
          # using label instead of caption prevents wrapping long lines
          convert << "label:#{@text}"
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
          convert << '-geometry' << "+#{text_left_margin}+#{band_top_position + text_top_margin}"
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
