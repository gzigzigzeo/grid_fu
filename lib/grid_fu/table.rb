module GridFu
  class Table
    include ActiveSupport::Configurable

    def initialize(&block)
      @columns    = []

      @body       = []
      @header     = []
      @footer     = []

      @body_row   = []
      @header_row = []
      @footer_row = []

      @definition = block
    end

    class << self
      # Defines table and returns it.
      #
      # Example:
      #   table = GridFu.define do
      #     ...
      #   end
      #
      #   puts table.to_html(self, users, User)
      def define(*args, &block)
        self.new(&block)
      end

      # Defines table, renders it and returns the result.
      #
      # Example:
      #   puts GridFu.render(self, users, User) do
      #     ...
      #   end
      def render(*args, &block)
        define(&block).to_html(*args)
      end
    end
  end
end