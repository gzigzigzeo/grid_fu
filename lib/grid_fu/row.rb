module GridFu
  class Row < Element
    attr_reader :cells

    def initialize(*args, &block)
      self.cells = []
      config.tag = 'tr'

      super
    end

    protected
    def html_content(member, index)
      html = cells.map do |cell|
        cell.to_html(member, index)
      end
      html.join
    end

    def cell(*args, &block)
      self.cells << Cell.new(*args, &block)
    end

    attr_writer :cells
  end
end
