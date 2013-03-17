# GridFu

Inspired by discussion at: https://github.com/evilmartians/slashadmin/issues/3.
Rails table renderer that tries to be DRY & flexible.

NB!: WIP, experiment so do not rely on it until u see this warning.

## Usage

Somwhere in your view:

```erb
<%=
  GridFu::Table.render(collection, User) do |t|
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
GridFu::Table.render(self, collection, User) do |t|
  t.column do
    t.header { |member_class, index| member_class.to_s }

    # Each collection member will be presented with two rows.
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
    <tr data-id="2">...</tr>
    ...
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
wrapped within tag on render, but content will be rendered.

Any option could be a block. Block accepts member or member class and index and
a reference to table's object.

## Reusing

```ruby
class AdminTable < GridFu::Table
  config.table = { tag: 'table', html: { class: 'table' } }

  def move_icon_column
    column do |c|
      c.header
      c.body { |member, _, table| link_to icon(:move), '#' }
    end
  end

  def check_box_column
    ...
  end
end

puts AdminTable.render(self, users, User) do
  t.move_icon_column
  t.column :name
  t.check_box_column
end
```

## Evaluation context

Note that in first #render parameter you must pass the context for blocks to evaluate.

```ruby
class AdminTable < GridFu::Table
  def move_icon_column
    column do |c|
      c.header
      c.body { |member, index, t| link_to icon(:move), '#' }
    end
  end
end
```

c.body value block context will be set to the AdminTable instance by default, so
link_to will not work without passed context. All blocks are evaluated with #instance_exec.

Last parameter is a reference to GridFu::Table instance.

## Twitter-style pagination

```ruby
# Definition may be stored for later use
definition = AdminTable.define do |t|
  ...
end

# Renders only body
AdminTable.render_body_rows(self, users, User, &definition)
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
5. Block contexts.
