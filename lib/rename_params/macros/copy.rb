module RenameParams
  module Macros
    class Copy < Base
      class << self

        def def_copy(klass, *args)
          copy_param = args.shift
          options = build_options(*args)

          klass.prepend_before_action(options[:filters]) do |controller|
            params = RenameParams::Params.new(controller.params, controller)
            params.copy(copy_param, options[:to], options[:namespace]) if options[:to]
          end
        end

        private

        def build_options(args = {})
          {
            to: move_to_options(:to, args),
            namespace: namespace_options(args),
            filters: filter_options(args)
          }
        end
      end
    end
  end
end
