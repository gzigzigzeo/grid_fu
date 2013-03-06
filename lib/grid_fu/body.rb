module GridFu
  class Body < Section
    config.tag = 'tbody'

    protected
    def html_content(collection, resource_class)
      html = collection.map.with_index do |member, index|
        rows.map { |row| row.to_html(member, index) }.join(' ')
      end
      html.join
    end
  end
end