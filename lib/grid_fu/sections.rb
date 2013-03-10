module GridFu
  class Section < Element
    config.render_nested_elements = %w(row)
  end

  class Body < Section
    config.tag = 'tbody'

    nest :row, BodyRow

    protected
    def html_content(collection)
      html = collection.map.with_index do |member, index|
        row.map { |row| row.to_html(member, index) }.join(' ')
      end
      html.join
    end
  end

  class Header < Section
    config.tag = 'thead'

    nest :row, HeaderRow
  end

  class Footer < Section
    config.tag = 'tfoot'

    nest :row, FooterRow
  end
end
