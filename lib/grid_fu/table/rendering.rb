module GridFu
  # TODO: Code is complicated, should divide & simplify, also codeclimate reports D.
  class Table
    # Renders collection as html table.
    def to_html(collection, member_class = nil)
      table = apply_defaults(:table)

      tag(table, member_class) do
        html = []

        html << header_to_html(member_class)
        html << body_to_html(collection, member_class)
        html << footer_to_html(member_class)

        html.join
      end
    end

    # Renders table header
    def header_to_html(member_class)
      section_to_html(:header, member_class) do |key, cell_options, index, &block|
        if block.present?
          block.call(member_class, index)
        elsif key.present?
          member_class.human_attribute_name(key)
        end
      end
    end

    # Render table body
    def body_to_html(collection, member_class = nil)
      rows = get_section(:body)
      section = apply_defaults(:body)

      tag(section, member_class) do
        members = collection.map do |member|
          member_rows = rows.map.with_index do |row, index|
            row_options = self[:body_row][index] || [ {} ]
            row_options = row_options.first
            row_options = apply_defaults(:body_row, row_options)

            tag(row_options, member_class, index) do
              cols = row.map do |column|
                key, cell_options, value_block = column
                cell_options = apply_defaults(:body_cell, cell_options)

                tag(cell_options) do
                  if value_block.present?
                    @definition_binding.instance_exec(member, index, &value_block)
                  elsif key.present?
                    member.send(key)
                  end
                end
              end
              cols.join
            end
          end
          member_rows.join
        end
        members.join
      end
    end

    # Renders table footer
    def footer_to_html(member_class = nil)
      section_to_html(:footer, member_class) do |key, cell_options, index, &block|
        block.call(member_class, index) if block.present?
      end
    end

    private
    def section_to_html(section, member_class, &block)
      section_key, row_key, cell_key = section, :"#{section}_row", :"#{section}_cell"

      rows = get_section(section)
      section = apply_defaults(section_key)

      tag(section, member_class) do
        rows = rows.map.with_index do |row, index|
          row_options = self[row_key][index] || []
          row_options = row_options.first
          row_options = apply_defaults(row_key, row_options)

          tag(row_options, member_class, index) do
            cols = row.map do |column|
              key, cell_options, value_block = column
              cell_options = apply_defaults(cell_key, cell_options)

              tag(cell_options, member_class) do
                block.call(key, cell_options, index, &value_block)
              end
            end
            cols.join
          end
        end
        rows.join
      end
    end

    # Gets array of rows for table section. If cell is missing - returns nil.
    def get_section(section)
      rows = self[:columns].map { |c| c[section.to_sym] }
      max_row = rows.map(&:size).max

      (0..max_row-1).map do |n|
        rows.map { |c| c[n] }
      end
    end

    # Applies default options to given options.
    def apply_defaults(key, options = nil)
      defaults = config[key] || {}
      options  = options || self[key].try(:first) || {}
      defaults.merge(options)
    end

    # Renders html tag with given options and content.
    # Yields options which are procs with given options.
    def tag(options, *args, &block)
      tag, html_options = get_options([:tag, :html], options, *args)

      html = []
      if tag.present?
        html << "<#{tag}"
         if html_options.present?
          html << ' '
          html << to_html_args(html_options)
        end
        html << '>'
      end
      html << yield if block_given?
      html << "</#{tag}>" if tag.present?
      html.join
    end

    # Returns expected options. If option is a block yields it with given args.
    def get_options(expected, options, *args)
      expected.map do |option|
        option = options[option]
        option.is_a?(Proc) ? option.call(*args) : option
      end
    end

    # Translates hash to HTML attributes string. Accepts nested attributes.
    #
    # Example:
    #   to_html_args(ref: true, data: { id: 1 }) # ref="true" data-id="1"
    def to_html_args(options, prepend = nil)
      options = options || {}
      html_args = options.map do |key, value|
        if value.is_a?(Hash)
          to_html_args(value, key)
        else
          key = "#{prepend}-#{key}" if prepend.present?
          %{#{key}="#{value}"}
        end
      end
      html_args.join(' ')
    end
  end
end
