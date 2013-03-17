# GridFu

Inspired by discussion at: https://github.com/evilmartians/slashadmin/issues/3.
Rails table renderer that tries to be DRY & flexible.

## Usage

Somwhere in your view:

```erb
<%=
  GridFu.render(collection, User) do |t|
    t.column :id
    t.column :name
  end
%>
```

Will produce the following:

```html
<table>
  <thead><tr><th>Id</th><th>User name</th></tr></thead>
  <tbody>
    <tr><td>1</td><td>John Doe</td></tr>
    <tr>...</tr>
  </tbody>
  <tfoot><tr><td></td><td></td></tr></tfoot>
</table>
```

## Complex example

```ruby
GridFu.render(collection, User) do |t|
  t.column do
    t.header { |member_class, index| member_class.to_s }

    # Each collection member will be presented with two rows
    # Let call them odd and even.
    t.body   :id
    t.body do |member, index|
      if member.created_at < 5.years.ago
        "Old member"
      end
    end
  end

  t.column do
    t.header :name
    t.body   :name
    t.body   { |member| "Warning!" if member.dangerous? }
  end

  t.body     html: { class: 'users' }
  t.body_row html: { |member| { data: { id: member.id } } } # Options for odd rows
  t.body_row html: { class: 'smaller' }                     # Options for even rows
end

Will produce the following:
```html
<table>
  <thead><tr><th>User</th></tr></thead>
  <tbody class="users">
    <tr data-id="1"><td>1</td><td>Old member</td></tr>
    <tr class="smaller"><td>John doe</td><td>Warning!</td></tr>
    <tr>...</tr>
  </tbody>
</table>
```

## Global configuration

You could set default options for every element in your table:

```ruby
GridFu::Table.config.table    = { html: { class: 'table-condenced' }, tag: 'table' }
GridFu::Table.config.body     = { html: { class: 'table-body' }, tag: 'tbody' }
GridFu::Table.config.body_row = { html: -> { |member| { html: { data: { id: member.id } } } }
```

You must specify tag for table element. If tag is nil section will not be
wrapped with tag on render.

Any option could be a block. Block accepts member or member class and index.

The other way is to inherit table class:

```ruby
class AdminTable < GridFu::Table
  config.table = { tag: 'table', html: { class: 'table' } }

  def move_column
    column do |c|
      c.header
      c.body   { |member| link_to icon(:move), '#' }
    end
  end
end

puts AdminTable.render(users, User) do
  move_column
  column :name
  check_box_column
end
```
## Installation

Add this line to your application's Gemfile:

    gem 'grid_fu'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install grid_fu

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## TODO

1. Think about sorting.
2. Formatted output.
3. Authospan.
4. View helper for rendering
