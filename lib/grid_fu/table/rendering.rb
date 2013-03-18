module GridFu
  # TODO: Code is complicated, should divide & simplify, also codeclimate reports D.
  class Table
    # Renders collection as html table.
    def to_html(collection, member_class = nil)
      table = apply_defaults(:table)

      render_tag(table, member_class) do
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
          instance_exec(member_class, index, self, &block)
        elsif key.present?
          member_class.human_attribute_name(key)
        end
      end
    end

    # Render table body
    def body_to_html(collection, member_class = nil)
      section = apply_defaults(:body)
      render_tag(section, member_class) do
        render_body_rows(collection, member_class)
      end
    end

    # Renders only rows
    def render_body_rows(collection, member_class = nil)
      rows = get_section(:body)

      members = collection.map do |member|
        member_rows = rows.map.with_index do |row, index|
          row_options = self[:body_row][index] || [ {} ]
          row_options = row_options.first
          row_options = apply_defaults(:body_row, row_options)

          render_tag(row_options, member, index) do
            cols = row.map do |column|
              key, cell_options, value_block = column
              cell_options = apply_defaults(:body_cell, cell_options)

              render_tag(cell_options, member, index, self) do
                if value_block.present?
                  @context.instance_exec(member, index, self, &value_block)
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

    # Renders table footer
    def footer_to_html(member_class = nil)
      section_to_html(:footer, member_class) do |key, cell_options, index, &block|
        @context.instance_exec(member_class, index, self, &block) if block.present?
      end
    end

    private
    def section_to_html(section, member_class, &block)
      section_key, row_key, cell_key = section, :"#{section}_row", :"#{section}_cell"

      rows = get_section(section)
      section = apply_defaults(section_key)

      render_tag(section, member_class) do
        rows = rows.map.with_index do |row, index|
          row_options = self[row_key][index] || []
          row_options = row_options.first
          row_options = apply_defaults(row_key, row_options)

          render_tag(row_options, member_class, index) do
            cols = row.map do |column|
              key, cell_options, value_block = column
              cell_options = apply_defaults(cell_key, cell_options)

              render_tag(cell_options, member_class) do
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
      options  = options || self[key].try(:first).try(:first) || {}
      defaults.merge(options)
    end
  end
end
