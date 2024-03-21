module HomeHelper
  def search_options(elements, cat)
    res = ''
    elements.each do |element|
      res += content_tag :li, data: { controller: "map", action: 'click->map#search', category: cat, value: element[1]} do
        element[0]
      end
    end
    res.html_safe
  end
end
