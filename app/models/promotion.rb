class Promotion < ActiveRecord::Base

  belongs_to :book
  belongs_to :tag
  belongs_to :category
  belongs_to :publisher

  has_many :orders, dependent: :restrict

  validates :publisher, :started_at, :ended_at, presence: true
  validates :name, presence: true, if: "for_traffic_origin"

  validates :discount, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 1}, if: "discount"

  validate :validate_price_and_discount, :validate_book_tag_category, :started_at_ended_at

  validates :slug, uniqueness: true, allow_blank: true
  validates :slug, presence: true, if: "for_traffic_origin"

  attr_accessible :book_id, :category_id, :discount, :ended_at, :price, :publisher_id, :started_at, :tag_id, :slug, :link, :name, :for_traffic_origin

  private

  def validate_price_and_discount
    errors.add(:discount, "Price and discount can not be blank at the same time") if !price && !discount
    errors.add(:discount, "Price and discount can not be set at the same time") if price && discount
  end

  def validate_book_tag_category
    fill_count = 0
    [book, tag, category].each do |attr|
      fill_count += 1 if attr
    end

    errors.add(:book, "Book, tag and category can not be set at the same time") if fill_count == 3 || fill_count == 2
  end

  def started_at_ended_at
    errors.add(:started_at, "End time is early than start time") if started_at && ended_at && ended_at <= started_at
  end
end
