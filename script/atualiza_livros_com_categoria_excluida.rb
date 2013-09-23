#messages = []
Book.where("CATEGORY_ID IS NOT NULL").each do |book|
  if Category.where(id: book.category_id) == []
    #messages << "#book #{book.id} category #{book.category_id}"
    book.update_attributes(category_id: nil)
  end
end