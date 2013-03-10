module GridFu
  class Row < Element
    attr_reader :cells

    config.tag = 'tr'
    config.render_nested_elements = %w(cell)
  end

  class BodyRow < Row
    nest :cell, BodyCell

    protected
    def html_content(member, index)
      html = cell.map do |cell|
        cell.to_html(member, index)
      end
      html.join
    end
  end

  class HeaderRow < Row
    nest :cell, HeaderCell
  end

  class FooterRow < Row
    nest :cell, FooterCell
  end
end