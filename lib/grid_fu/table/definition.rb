module GridFu
  class Table
    config.table       = { tag: 'table' }

    config.header      = { tag: 'thead' }
    config.body        = { tag: 'tbody' }
    config.footer      = { tag: 'tfoot' }

    config.header_row  = { tag: 'tr' }
    config.body_row    = { tag: 'tr' }
    config.footer_row  = { tag: 'tr' }

    config.header_cell = { tag: 'th' }
    config.body_cell   = { tag: 'td' }
    config.footer_cell = { tag: 'td' }

    CONFIG_METHODS    = %w(
      table
      header
      body
      footer
      header_row
      body_row
      footer_row
    )

    CONFIG_METHODS.each do |option|
      define_method option do |options = {}, &block|
        self[option] << [options, block]
      end
    end

    def column( *args, &block )
      column = if block_given?
        Column.new(&block)
      else
        key = args.first
        column = Column.new do |c|
          c.header key
          c.body   key
          c.footer key
        end
      end
      self[:columns] << column.to_hash
    end

    private
    # Shortcut to instance_variable_get, just syntax sugar.
    def [](key)
      instance_variable_get("@#{key}")
    end
  end
end