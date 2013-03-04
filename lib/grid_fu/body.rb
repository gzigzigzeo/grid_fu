module GridFu
  class Body < Element
    attr_reader :rows

    def initialize(*args, &block)
      self.rows = []

      config.tag ||= 'tbody'

      super
    end

    protected
    def html_content(collection, resource_class)
      html = collection.map do |member|
        rows.map.with_index { |row, index| row.to_html(member, index) }.join(' ')
      end
      html.join
    end

    protected
    def row(*args, &block)
      self.rows << Row.new(&block)
    end

    attr_writer :rows
  end
end
