require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/inclusion'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/object/try'
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
  # TODO: Custom table class
  def define(*args, &block)
    Table.new(*args, &block)
  end
  module_function :define
end
