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

## Full DSL

```ruby
table = GridFu.define do
  html class: 'table'

  header do
    row do
      cell 'Id', html: { colspan: 5 }
      cell do
        'Doctor strangelove'
      end
    end
  end

  body do
    html class: 'sortable'
    row do
      html do |member, index|
        { data: { id: member.id, index: index } }
      end

      cell html: ->(member, _) { { data: { value: member.id } } } do |_, index|
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

    row html: { class: 'small' } do
      tag 'overriden_tr'

      cell :test do
        "test"
      end

      cell :age, formatter: :sample_formatter
    end
  end

  footer do
    row do
      cell html: { rowspan: 3 } do
        "On foot"
      end
    end
  end
end

puts table.to_html(collection)
```

Every element accepts:
* html - to customize default options.
* override_html - to completely override default html options.
* tag - to change tag name.

Default HTML options are:
* data-id - for tbody/tr.
* data-key - for tbody/tr/td.

Options which are set by blocks accepts:
* |member, index| - for row and cell inside body element.
* |collection, klass = nil| - for table, header and footer (and all nested elements)
* Same for body.

Method called with :formatter option accepts value, member and index.

You can override default html options for an element with :override_html
option.

You can specify two or more rows in body section. All of this rows will be
rendered for every collection item.

## Global configuration

Table elements can be customized at application level.

Somewhere in initializer:

```ruby
GridFu::Table.config.html     = { class: 'table' }
GridFu::HeaderRow.config.html = proc { |_, resource_class = nil|
  { class: resource_class.name.underscore }
}
```

You can use: Table, Header, Body, Footer, HeaderRow, BodyRow, FooterRow,
HeaderCell, BodyCell, FooterCell.

So, you can replace table with ordered list or something you need.

## Partial rendering

Could be useful for twitter-style pagination:

```ruby
table.element_to_html(:header, collection, User)
table.element_to_html(:body, collection, User)
table.element_to_html(:footer, collection, User)
```

## TODO

1. Think about sorting.
2. Formatted output.
3. Data attrs for everything.
4. Authospan.
5. :row as parameter.
6. Reusable cells: reuse :icon, :name, :icon, :checkbox, for: [:header, :footer]
7. Shortened cell definition
9. make request, response and so on accessible at definition scope.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
