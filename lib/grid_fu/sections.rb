module GridFu
  class Section < Element
    config.render_nested_elements = %w(row)
  end

  class Body < Section
    config.tag = 'tbody'

    nest :row, BodyRow
    nest_through :row, :cell

    protected
    def html_content(collection, resource_class = nil)
      html = collection.map.with_index do |member, index|
        row.map { |row| row.to_html(member, index) }.join(' ')
      end
      html.join
    end
  end

  class Header < Section
    config.tag = 'thead'

    nest :row, HeaderRow
    nest_through :row, :cell
  end

  class Footer < Section
    config.tag = 'tfoot'

    nest :row, FooterRow
    nest_through :row, :cell
  end
end
