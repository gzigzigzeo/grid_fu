require 'spec_helper'

describe 'Grid' do
  context 'defined fully' do
    subject { sample_table_full_described }

    it 'should render correctly' do
      subject.should have_tag 'table', with: { class: 'table' }, count: 1 do
        with_tag 'thead', count: 1 do
          with_tag 'th', text: 'Doctor strangelove', count: 1
          with_tag 'th', text: 'Id', count: 1
        end

        with_tag 'tbody', with: { class: 'sortable' }, count: 1 do
          sample_collection.each_with_index do |member, index|
            with_tag "tr[data-id='#{member.id}'][data-index='#{index}']"

            with_tag 'td', with: { 'data-value' => member.id }, text: index, count: 1
            with_tag 'td', text: member.id, count: 1
            with_tag 'td', text: "Dead at #{member.age}", count: 1
            with_tag 'td', text: "I hope this helps #{index}", count: 1

            with_tag 'overriden_tr'

            with_tag 'td', text: member.age
          end
        end

        with_tag 'tfoot', count: 1 do
          with_tag 'td', text: 'On foot', count: 1
        end
      end
    end
  end

  context 'defined shortly' do
    subject { sample_table_short }

    it 'should render correctly' do
      subject.should have_tag 'table', count: 1 do
        with_tag 'tbody', count: 1
        with_tag 'thead', count: 1
        with_tag 'tr', count: 4
      end
    end
  end

  context 'with active record objects' do
    subject { sample_table_active_record }

    it 'should get right headings from active record' do
      subject.should have_tag 'thead', count: 1 do
        with_tag 'th', text: 'Humanized id', count: 1
        with_tag 'th', text: 'Humanized age', count: 1
      end
    end
  end
end