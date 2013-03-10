module GridFu
  class Element
    class << self
      protected
      # Defines dsl method for configuring nested element.
      # If no args/block passed - returns currently defined elements as array.
      #
      # Example:
      #   class Table < Element
      #     nest :body, Body
      #   end
      #
      #   table = Table.new do
      #     body do
      #       (...)
      #     end
      #   end
      #
      #   table.body.first.to_html # <tbody>...</tbody>
      def nest(accessor_name, klass)
        define_method accessor_name do |*args, &block|
          items = instance_variable_get("@#{accessor_name}") || []
          return items if args.blank? && block.blank?

          value = klass.new(*args, &block)
          items.push(value)
          instance_variable_set("@#{accessor_name}", items)
          value
        end
        protected accessor_name
      end

      # Defines top-level shortcut DSL method.
      #
      # Example:
      #   class Body < Element
      #     nest :row, BodyRow
      #   end
      #
      #   class Table < Element
      #     nest_through :body, :row, :cell # Table#cell calls .body.row.cell
      #   end
      #
      #   table = Table.new do
      #     cell :id
      #   end
      #
      #   table.body.first.row.first.cell.first.to_html # <td data-name="id">...</td>
      def nest_through(*chain)
        nested_method = chain.last

        define_method nested_method do |*args, &block|
          _get_chained(self, chain.dup, *args, &block)
        end
      end
    end

    private
    def _get_chained(context, chain, *args, &block)
      key = chain.shift
      if chain.empty?
        context.send(key, *args, &block)
      else
        # Get last defined element, or define new blank
        nested_item = context.send(key).last || context.send(key) { }
        _get_chained(nested_item, chain, *args, &block)
      end
    end
  end
end