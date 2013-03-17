require 'spec_helper'

describe GridFu::Table do
  context 'customized setup' do
    subject do
      render_sample_table do |t|
        t.column do |t|
          t.header :id, html: ->(member_class) { { class: member_class.name } }
          t.header { 'Search id' }
          t.body   :id
          t.body   { 'Value id' }
        end

        t.column do |t|
          t.header :name
          t.body   { |member| member.value }
          t.footer { 'Footer name' }
        end

        t.body(html: ->(_) { { class: 'body' } })
        t.body_row({ html: { class: 'body-row-odd' } })
      end
    end

    it 'should render table with blank cells if none given for column' do
      subject.should have_tag 'th', count: 1, text: 'Humanized id', with: { class: 'SampleModel' }
      subject.should have_tag 'th', count: 1, text: 'Humanized name'
      subject.should have_tag 'th', count: 1, text: 'Search id'
      subject.should have_tag 'th', count: 1, text: ''

      subject.should have_tag 'tfoot > tr', count: 1
      subject.should have_tag 'tfoot > tr > td', count: 1, text: ''
      subject.should have_tag 'tfoot > tr > td', count: 1, text: 'Footer name'

      sample_collection.each do |item|
        subject.should have_tag 'tbody', with: { class: 'body' } do
          with_tag 'tr > td', text: item.id, count: 1
          with_tag 'tr > td', text: item.value, count: 1
        end
      end

      with_tag 'tbody > tr > td', text: 'Value id', count: 3
    end
  end
end