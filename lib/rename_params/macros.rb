module RenameParams
  module Macros
    extend ActiveSupport::Concern

    module ClassMethods
      def rename(*args)
        current_param = args.shift
        options = build_options(*args)

        before_filter options[:filters] do
          new_params = RenameParams::Params.new(params, self)
          new_params.convert(current_param, options[:convert], options[:namespace])
          new_params.rename(current_param, options[:to], options[:namespace])
        end
      end

      private

      def build_options(args = {})
        {
          to: args[:to],
          convert: args[:convert],
          namespace: namespace_options(args),
          filters: filter_options(args)
        }
      end

      def namespace_options(args = {})
        args[:namespace].is_a?(Array) ? args[:namespace] : [args[:namespace]].compact
      end

      def filter_options(args = {})
        {
          only: args.delete(:only),
          except: args.delete(:except)
        }.reject { |_, v| v.nil? }
      end
    end
  end
end

ActionController::API.send(:include, RenameParams::Macros) if defined?(ActionController::API)
ActionController::Base.send(:include, RenameParams::Macros) if defined?(ActionController::Base)