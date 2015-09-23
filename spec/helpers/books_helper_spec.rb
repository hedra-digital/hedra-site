require 'rails_helper'

RSpec.describe BooksHelper, :type => :helper do
  describe '.show_price' do
    subject { helper.show_price(book, book_type) }

    context 'when is a print book' do
      context 'when the book does not have a price_print' do
        let(:book) { Book.new }
        let(:book_type) { :print }

        it { is_expected.to be_nil }
      end

      context 'when exist a site promotion' do
        context 'when the site promotion have price' do
          let(:book) { Book.new(publisher_id: 666) }
          let(:book_type) { :print }

          before(:each) do
            publisher = create(:publisher)
            create(:promotion, price: 100.00, started_at: Time.zone.now.yesterday, ended_at: Time.zone.now.tomorrow, publisher: publisher)
            create(:promotion, price: 111.00, started_at: Time.zone.now.yesterday, ended_at: Time.zone.now.tomorrow, publisher: publisher)
            create(:promotion, price: 122.00, started_at: Time.zone.now.yesterday, ended_at: Time.zone.now.tomorrow, slug: 'some-fake-slug', publisher: publisher)
            create(:promotion, price: 133.00, started_at: Time.zone.now.yesterday, ended_at: Time.zone.now.tomorrow, for_traffic_origin: 1, slug: 'dummy-slug', name: 'dummy name', publisher: publisher)
            create(:promotion, price: 144.00, started_at: (Time.zone.now - 10.days), ended_at: Time.zone.now.yesterday, publisher: publisher)
            create(:promotion, price: 155.00, started_at: Time.zone.now.yesterday, ended_at: Time.zone.now.tomorrow, book_id: 1, publisher: publisher)
            create(:promotion, price: 166.00, started_at: Time.zone.now.yesterday, ended_at: Time.zone.now.tomorrow, tag_id: 1, publisher: publisher)
            create(:promotion, price: 177.00, started_at: Time.zone.now.yesterday, ended_at: Time.zone.now.tomorrow, publisher: publisher)
          end

          it 'returns one promotion' do
            pending 'is this a valid case? Should exist a site promotion with price for all books?'
            fail
          end

          it 'TBD' do
            pending 'What about the case where there are multiple promotions???'
            fail
          end
        end
      end
    end
  end
  # it 'hola' do
  #   expect(helper.authors(nil)).to eq(true)
  # end
end
