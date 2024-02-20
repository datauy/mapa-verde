class StaticPagesController < ApplicationController
  def home
    organizations = []
    Organization.
    includes(:zones).
    where(enabled: true).
    each do |o|
      org = o.as_json
      org.merge!(zones: o.zones.as_json)
      logger.debug org.inspect
      organizations.push org
    end
    @organizations = organizations.to_json
    @activities = Activity.where('starts > ?', Date.today).order(:starts).page(params[:acts_page]).per(6)
    @news = New.order(:created_at).page(params[:news_page]).per(3)
  end
  def about
  end
  def faqs
  end
  def thank_you
  end
  def other_actions
    @step = 0
  end
end
