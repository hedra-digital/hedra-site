class Promotion < ActiveRecord::Base

  belongs_to :book
  belongs_to :tag
  belongs_to :category
  belongs_to :publisher

  validates_presence_of :publisher, :started_at, :ended_at

  validates :discount, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 1}, if: "discount"

  validate :validate_price_and_discount, :validate_book_tag_category, :started_at_ended_at

  validates_uniqueness_of :slug, :allow_blank => true

  attr_accessible :book_id, :category_id, :discount, :ended_at, :price, :publisher_id, :started_at, :tag_id, :slug, :link


  private

  def validate_price_and_discount
    self.errors.add(:discount, "Price and discount can not be blank at the same time") if ( !self.price and !self.discount)
    self.errors.add(:discount, "Price and discount can not be set at the same time") if ( self.price and self.discount)
  end

  def validate_book_tag_category
    fill_count = 0
    [self.book, self.tag, self.category].each do |attr|
      fill_count += 1 if attr
    end

    self.errors.add(:book, "Book, tag and category can not be set at the same time") if fill_count == 3 or fill_count == 2
  end

  def started_at_ended_at
    self.errors.add(:started_at, "End time is early than start time") if self.started_at and self.ended_at and self.ended_at <= self.started_at
  end
end
