require 'ostruct'

class ActiveRecordMock
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

def sample_helper_function(arg)
  "I hope this helps #{arg}"
end

def sample_formatter(key, member, index)
  "Formatter for #{member[key]}"
end

def sample_table_full_described_definition
  GridFu.define do
    html_options class: 'table'

    header do
      row do
        cell 'Id', html_options: { colspan: 5 }
        cell do
          'Doctor strangelove'
        end
      end
    end

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
        cell do |_, index|
          sample_helper_function(index)
        end
      end

      row html_options: { class: 'small' } do
        tag 'overriden_tr'

        cell :test do
          "test"
        end

        cell :age, formatter: :sample_formatter
      end
    end

    footer do
      row do
        cell html_options: { rowspan: 3 } do
          "On foot"
        end
      end
    end
  end
end

def sample_table_full_described
  sample_table_full_described_definition.to_html(sample_collection)
end

def sample_table_short
  table = GridFu.define do
    header do
      cell 'Id'
      cell 'Age'
    end

    cell :id
    cell :age
  end
  table.to_html(sample_collection)
end

def sample_table_active_record
  table = GridFu.define do
    header do
      cell :id
      cell :age
      cell "Custom string"
      cell do
        "Custom block"
      end
    end
    cell :id
    cell :age
  end
  table.to_html(sample_collection, ActiveRecordMock)
end