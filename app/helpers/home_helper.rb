module HomeHelper
  def acts_tags(acts)
    res = ''
    acts.each do |act|
      res += content_tag :a, class: "btn act-tag", href: activity_path(act[:id]), target: '_blank', data: { turbo: false } do
        concat @subjects[act[:subject_id]][:icon].present? ? image_tag(@subjects[act[:subject_id]][:icon]) : image_tag('/images/icon_default.svg', class: "icon-default")
        concat content_tag :span, "#{act[:title]}, #{act[:starts].present? ? act[:starts].strftime('%Y-%m-%d') : ''}"
      end
    end
    res.html_safe
  end
end
