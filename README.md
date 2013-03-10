# GridFu

Inspired by discussion at: https://github.com/evilmartians/slashadmin/issues/3.
Rails table renderer that tries to be flexible.

## Installation

Add this line to your application's Gemfile:

    gem 'grid_fu'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install grid_fu

## Usage

Somwhere in your app:

```ruby
short_table = GridFu.define do
  cell :id
  cell :name
end

puts short_table.to_html(collection, User)
```

You will see following:

```html
# <table>
#   <thead><tr><th>Id</th><th>User name</th></tr></thead>
#   <tbody>
#     <tr><td>1</td><td>John Doe</td></tr>
#     <tr>...</tr>
#   </tbody>
# </table>
```

## Full definition

```ruby
table = GridFu.define do
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

puts table.to_html(collection)
```

Every element accepts:
* html_options - to customize default options.
* override_html_options - to completely override default html options.
* tag - to change tag name.

Default HTML options are:
* data-id - for tbody/tr.
* data-key - for tbody/tr/td.

You can override default html options for an element with :override_html_options
option.

You can specify two or more rows in body section. All of this rows will be
rendered for every collection item.

## Global configuration

Table elements can be customized at application level.

Somewhere in initializer:

```ruby
GridFu::Table.html_options     = { class: 'table' }
GridFu::HeaderRow.html_options = proc { |_, resource_class = nil|
  { class: resource_class.name.underscore }
}
```

You can use: Table, Header, Body, Footer, HeaderRow, BodyRow, FooterRow,
HeaderCell, BodyCell, FooterCell.

So, you can replace table with ordered list or something you need.

## TODO

1. Think about sorting.
2. Formatted output.
3. Data attrs for everything.
4. Authospan.
5. :row as parameter.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
