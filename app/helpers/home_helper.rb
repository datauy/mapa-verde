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
  def icon_tag(elements)
    res = ''
    elements.each do |element|
      logger.info "\n\n#{element.inspect}\n\n"
      res += content_tag :div, class: "icon-tag" do
        concat element[:icon].present? ? image_tag(element[:icon]) : image_tag('/images/icon_default.svg', class: "icon-default")
        concat content_tag :span, element[:name]
      end
    end
    res.html_safe
  end
  def acts_tags(acts)
    res = ''
    acts.each do |act|
      res += content_tag :a, class: "btn act-tag", href: activity_path(act[:id]) do
        concat @subjects[act[:subject_id]][:icon].present? ? image_tag(@subjects[act[:subject_id]][:icon]) : image_tag('/images/icon_default.svg', class: "icon-default")
        concat content_tag :span, "#{act[:title]}, #{act[:starts].strftime('%Y-%m-%d')}"
      end
    end
    res.html_safe
  end
end
