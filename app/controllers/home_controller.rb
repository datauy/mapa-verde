class HomeController < ApplicationController
  def index
    @otype_options = Organization.includes(:organization_type).distinct.pluck(:'organization_types.name', :'organization_types.id')
    @zone_options = Organization.includes(:zones).where.not(zones: nil).distinct.pluck(:'zones.name', :'zones.id')
    @subject_options = Organization.includes(:subjects).distinct.pluck(:'subjects.name', :'subjects.id')
    @action_options = Organization.includes(:operations).distinct.pluck(:'operations.name', :'operations.id')
    @total = Organization.all.count
    #self.search
  end
  def search
    @organizations = []
    zone_ids = []
    @zones = {}
    orgs = Organization.
    includes(:zones)
    logger.info " \n\n\n PASA PARAMS \n\n\n\n #{params.inspect}"
    if params['otypes'].present?
      logger.info "\n\n\n PASA OTYPE \n\n\n\n"
      orgs = orgs.where(organization_type: params['otypes'].split(','))
    end
    if params['subjects'].present?
      orgs = orgs.where(subject: params['subjects'].split(','))
    end
    if params['actions'].present?
      orgs = orgs.where(operations: params['actions'].split(','))
    end
    if params['zones'].present?
      orgs = orgs.where(zones: params['zones'].split(','))
    end
    orgs.each do |o|
      org = o.as_json
      org.merge!(zones: o.zones.ids)
      zone_ids = zone_ids | o.zones.ids
      #logger.debug org.inspect
      @organizations.push org
    end
    Zone.find(zone_ids).each do |z|
      @zones[z.id] = z
    end
    @showing = orgs.count
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end
end
