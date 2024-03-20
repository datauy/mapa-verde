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
        logger.info "JSJSJSJSJS"
      }
    end
  end
end
