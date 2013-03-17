require 'spec_helper'

describe GridFu::Table do
  context 'minimal setup' do
    subject do
      render_sample_table do |t|
        t.column :id
        t.column :age
      end
    end

    it 'should render simple table with header, body and footer by default' do
      subject.should have_tag 'table', count: 1
      subject.should have_tag 'table > thead', count: 1 do
        with_tag 'tr', count: 1
        with_tag 'tr > th', count: 1, text: 'Humanized id'
        with_tag 'tr > th', count: 1, text: 'Humanized age'
      end

      subject.should have_tag 'table > tbody', count: 1 do
        with_tag 'tr', count: sample_collection.size
        sample_collection.each do |item|
          with_tag 'tr > td', count: 1, text: item.id
          with_tag 'tr > td', count: 1, text: item.age
        end
      end

      subject.should have_tag 'table > tfoot', count: 1 do
        with_tag 'tr', count: 1
        with_tag 'tr > td', count: 2
      end
    end
  end
end
