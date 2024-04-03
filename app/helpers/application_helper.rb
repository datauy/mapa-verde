module ApplicationHelper
  include Pagy::Frontend

  def search_options(elements, cat, controller)
    res = ''
    elements.each do |element|
      res += content_tag :li, data: { controller: "#{controller}", action: "click->#{controller}#search", category: cat, value: element[1]} do
        element[0]
      end
    end
    res.html_safe
  end

end
