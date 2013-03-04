require 'active_support/core_ext/class/attribute_accessors'
require 'active_support/core_ext/object/blank'
require 'active_support/configurable'

require 'grid_fu/version'
require 'grid_fu/element'
require 'grid_fu/table'
require 'grid_fu/row'
require 'grid_fu/body'
require 'grid_fu/cell'

module GridFu
  def define(*args, &block)
    Table.new(*args, &block)
  end
  module_function :define
end
