# GridFu

https://github.com/evilmartians/slashadmin/issues/3

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

        cell :id, formatter: :sample_formatter
      end
    end

    footer do
      row do
        cell html_options: { rowspan: 3 } do
          "noop"
        end
      end
    end
  end

  puts table.to_html(collection)
```

Every element accepts:
* tag
* html_options
* override_html_options


## Shortened definition

## Global configuration options

## Rendering behaviour override

## TODO

0. Simplify Table class (options) ~+
1. Default header & footer if none present. ~+
2. Render body, footer and header separately ~+
3. Specs. ~+
4. Sort?
5. Nice output.
6. Default data attrs for everything. ~
7. Rowspan
8. :span
9. Footer ~+
10. Header ~+
12. Avoid body block if there's no header/footer. ~+
13. value: :function cell param

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
