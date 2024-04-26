module ActivitiesHelper
  def activity_address(activity)
    content_tag :div, class: 'activity-address' do
      if activity.address.starts_with?('http')
        link_to activity.address, activity.address, target: '_blank', data: {turbo: false}
      else
        content_tag :span, "#{activity.address}#{activity.location.present? ? ', '+activity.location.name : ''}#{activity.state.present? ? ', '+activity.state.name : ''}"
      end
    end
  end
end
