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
  #
  def search_icon_options(elements, cat, controller)
    res = ''
    elements.each do |element|
      res += content_tag :li, data: { controller: "#{controller}", action: "click->#{controller}#search", category: cat, value: element[:value]} do
        self.icon_tag([element])
      end
    end
    res.html_safe
  end
  #
  def icon_tag(elements)
    res = ''
    elements.each do |element|
      res += content_tag :div, class: "icon-tag" do
        concat element[:icon].present? ? image_tag(element[:icon]) : image_tag('/images/icon_default.svg', class: "icon-default")
        concat content_tag :span, element[:name]
      end
    end
    res.html_safe
  end

end
