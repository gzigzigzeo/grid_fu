module GridFu
  class Table < Element
    config.tag = 'table'
    config.render_nested_elements = %w(header body footer)
    config.allowed_configuration_options = %w(tag html_options)

    nest :header, Header
    nest :body, Body
    nest :footer, Footer

    #nest_through cell: { body: :row }
  end
end