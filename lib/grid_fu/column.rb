class Column
  def initialize(&block)
    @column = Hash.new { |hash, key| hash[key.to_sym] = [] }
    yield self
  end

  def to_hash
    @column
  end

  COLUMN_SETTERS = %w(header body footer).map(&:to_sym)

  COLUMN_SETTERS.each do |column|
    define_method column do |*args, &block|
      options = args.extract_options!
      options = [args.first, options, block]
      @column[column] << options
    end
  end
end
