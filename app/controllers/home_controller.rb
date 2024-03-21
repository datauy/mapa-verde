class HomeController < ApplicationController
  def index
    @organizations = []
    zone_ids = []
    @zones = {}
    @otypes = []
    Organization.
    includes(:zones).
    where(enabled: true).
    each do |o|
      org = o.as_json
      org.merge!(zones: o.zones.ids)
      zone_ids = zone_ids | o.zones.ids
      #logger.debug org.inspect
      @organizations.push org
      @otypes.push o.otype unless @otypes.include? o.otype
    end
    Zone.find(zone_ids).each do |z|
      @zones[z.id] = z
    end
    respond_to do |format|
      format.html
      format.turbo_stream {
        logger.info "\n\nTURBO HOME\n\n"
      }
    end
  end
  def search
    @organizations = []
    zone_ids = []
    @zones = {}
    @otypes = []
    orgs = Organization.
    includes(:zones).
    where(enabled: true)
    if params['otype'].present?
      orgs.where(otype: params['otype'])
    end
    if params['subject'].present?
      orgs.where(otype: params['subject'])
    end
    if params['actions'].present?
      orgs.where(otype: params['actions'])
    end
    if params['zones'].present?
      orgs.where(otype: params['zones'])
    end
    orgs.each do |o|
      org = o.as_json
      org.merge!(zones: o.zones.ids)
      zone_ids = zone_ids | o.zones.ids
      #logger.debug org.inspect
      @organizations.push org
      @otypes.push o.otype unless @otypes.include? o.otype
    end
    Zone.find(zone_ids).each do |z|
      @zones[z.id] = z
    end
    respond_to do |format|
      format.html
      format.turbo_stream {
        logger.info "\n\nTURBO HOME\n\n"
      }
    end
    respond_to do |format|
      format.html
      format.turbo_stream {
        logger.info "\n\nTURBO HOME SEARCH\n\n"
      }
    end
  end
end
