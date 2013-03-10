module GridFu
  class Element
    class << self
      protected
      def nest(accessor_name, klass)
        define_method accessor_name do |*args, &block|
          items = instance_variable_get("@#{accessor_name}") || []
          return items if args.blank? && block.blank?

          value = klass.new(*args, &block)
          items.push(value)
          instance_variable_set("@#{accessor_name}", items)
        end
        protected accessor_name
      end

      def option_not_defined(name)
        proc {
          raise NotImplementedError, "Configuration option #{name} does not defined"
        }
      end
    end
  end
end