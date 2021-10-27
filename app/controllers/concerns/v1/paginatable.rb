module V1::Paginatable
  def paginate(collection, params)
    page_size = per_page(params[:per_page])
    page = page_number(params[:page])
    collection.offset(page * page_size).limit(page_size)
  end

  def per_page(size)
    size = size&.to_i || 20
    size.positive? ? size : 20
  end

  def page_number(page)
    page_num = page&.to_i || 1
    page_num.positive? ? page_num - 1 : 0
  end
end
