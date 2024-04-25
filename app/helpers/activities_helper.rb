module ActivitiesHelper
  def activity_address(activity)
    logger.info("\nADDRESS\n#{activity.inspect}\n")
    content_tag :div, class: 'activity-address' do
      if activity.address.starts_with?('http')
        link_to activity.address
      else
        content_tag :span, "#{activity.address}#{activity.location.present? ? ', '+activity.location.name : ''}#{activity.state.present? ? ', '+activity.state.name : ''}"
      end
    end
  end
end
