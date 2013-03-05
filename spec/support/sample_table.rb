require 'ostruct'

def sample_collection
  [
    OpenStruct.new(id: 10, age: 27, value: 'Jim Morrison'),
    OpenStruct.new(id: 20, age: 70, value: 'William Blake'),
    OpenStruct.new(id: 30, age: 89, value: 'Robert Lee Frost')
  ]
end

def sample_helper_function
  "I hope this helps"
end

def sample_table_full_described
  GridFu.define do
    html_options class: 'table'
    body do
      html_options class: 'sortable'
      row do
        html_options do |member, index|
          { data: { id: member.id, index: index } }
        end

        cell html_options: ->(member, _) { { data: { value: member.id } } } do |_, index|
          index
        end
        cell :id
        cell :age do |member, _|
          "Dead at #{member.age}"
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

def sample_table_full_described_html
  sample_table_full_described.to_html(sample_collection)
end