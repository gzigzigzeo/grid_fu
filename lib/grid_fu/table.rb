module GridFu
  class Table
    include ActiveSupport::Configurable

    def initialize(context, &block)
      @columns    = []

      @body       = []
      @header     = []
      @footer     = []

      @body_row   = []
      @header_row = []
      @footer_row = []

      @context    = context

      @context.instance_exec(self, &block)
    end

    class << self
      # Renders it and returns the result.
      #
      # Example:
      #   puts GridFu.render(self, users, User) do
      #     ...
      #   end
      def render(context, *args, &block)
        new(context, &block).to_html(*args)
      end
    end
  end
end