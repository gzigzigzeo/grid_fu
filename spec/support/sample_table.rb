require 'ostruct'

def sample_collection
  [
    OpenStruct.new(id: 1, age: 27, value: 'Jim Morrison'),
    OpenStruct.new(id: 1, age: 70, value: 'William Blake'),
    OpenStruct.new(id: 1, age: 89, value: 'Robert Lee Frost')
  ]
end

def sample_helper_function
  "I hope this helps"
end

def sample_table
  GridFu.define do
    body do
      html_options class: 'sortable'
      row do
        html_options do |member, index|
          { data: { id: member.id } }
        end

        cell html_options: ->(value, _, _) { { data: { value: value } } } do |_, _, index|
          index
        end
        cell :id
        cell :age do |value, _, _|
          "Dead at #{value}"
        end
        cell do
          sample_helper_function
        end
      end

      row html_options: { class: 'small' } do
        tag 'div'
      end
    end
  end
end