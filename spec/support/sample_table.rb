require 'ostruct'

class SampleModel
  def self.human_attribute_name(name)
    "Humanized #{name.to_s}"
  end
end

def sample_collection
  [
    OpenStruct.new(id: 10, age: 27, value: 'Jim Morrison'),
    OpenStruct.new(id: 20, age: 70, value: 'William Blake'),
    OpenStruct.new(id: 30, age: 89, value: 'Robert Lee Frost')
  ]
end

def render_sample_table(&block)
  GridFu::Table.render(self, sample_collection, SampleModel, &block)
end