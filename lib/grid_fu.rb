require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/inclusion'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/object/try'
require 'active_support/core_ext/array/extract_options'
require 'active_support/configurable'

require 'grid_fu/version'
require 'grid_fu/element'
require 'grid_fu/element/configuration'
require 'grid_fu/element/rendering'
require 'grid_fu/element/nesting'
require 'grid_fu/cells'
require 'grid_fu/rows'
require 'grid_fu/sections'
require 'grid_fu/table'

module GridFu
  # Defines table and returns it.
  #
  # Example:
  #   table = GridFu.define( html: { class: 'table' } ) do
  #     ...
  #   end
  #
  #   puts table.to_html(collection)
  def define(*args, &block)
    Table.new(*args, &block)
  end

  # Defines table, renders it and returns the result
  #
  # Example:
  #   puts GridFu.render(collection, html: { class: 'table' } ) do
  #     ...
  #   end
  def render(*args, &block)
    options = args.extract_options!
    Table.new(options, &block).to_html(*args)
  end

  module_function :define, :render
end
