module ActivitiesHelper
  def activity_address(activity)
    content_tag :div, class: 'activity-address' do
      if activity.address.starts_with?('http')
        link_to '<i class="fa-solid fa-external-link"></i>Dónde'.html_safe, activity.address, class: 'btn main-button', target: '_blank', data: {turbo: false}
      else
        content_tag :span, "<i class='fas fa-location-dot icon-tag'></i> #{activity.address}#{activity.location.present? ? ', '+activity.location.name : ''}#{activity.state.present? ? ', '+activity.state.name : ''}".html_safe
      end
    end
  end
end
