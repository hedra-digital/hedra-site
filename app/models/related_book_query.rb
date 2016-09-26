class RelatedBookQuery
  
  private_class_method :new
  
  def initialize(book, limit)
  	@book = book
  	@limit = limit
  end

  def self.find(book, limit)
  	related = new(book, limit)
  	related.all
  end

  def all
  	related_book.sort_by(&:title).first(@limit)
  end

  private

  def related_book
  	@book.tags.map(&:books).flatten.uniq
  end
end
