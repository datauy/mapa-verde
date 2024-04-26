class HomeController < ApplicationController
  def index
    @otype_options = Organization.includes(:organization_type).distinct.pluck(:'organization_types.name', :'organization_types.id')
    @zone_options = Organization.includes(:zones).where.not(zones: nil).distinct.pluck(:'zones.name', :'zones.id')
    @subject_options = Organization.includes(:subjects).distinct.pluck(:'subjects.name', :'subjects.id')
    logger.info "\nSUBJCTS\n#{@subject_options.inspect}\n\n"
    @action_options = Organization.includes(:operations).distinct.pluck(:'operations.name', :'operations.id')
    @total = Organization.all.count
    #self.search
  end
  def search
    @total = Organization.all.count
    @organizations = []
    zone_ids = []
    subjs_ids = []
    actions_ids = []
    @zones = {}
    @subjects = {}
    @actions = {}
    orgs = Organization.includes(:organization_type)
    if params['otypes'].present?
      orgs = orgs.where(organization_type: params['otypes'].split(','))
    end
    if params['subjects'].present?
      orgs = orgs.joins(:subjects).where(subjects: params['subjects'].split(','))
    end
    if params['actions'].present?
      orgs = orgs.joins(:operations).where(operations: params['actions'].split(','))
    end
    if params['zones'].present?
      orgs = orgs.joins(:zones).where(zones: params['zones'].split(','))
    end
    if params['text'].present?
      str = params['text'].downcase
      orgs = orgs.where("name like :value or description like :value or volunteers_description like :value", value: "%#{str.strip.downcase}%")
    end
    orgs.each do |o|
      org = o.as_json
      org.merge!(zones: o.zones.ids)
      org.merge!(subjects: o.subjects.ids)
      org.merge!(actions: o.operations.ids)
      org.merge!(organization_type: o.organization_type.name)
      org.merge!(logo: o.logo.attached? ? url_for(o.logo) : '/images/logo_mapa_verde.svg')
      org.merge!(activities: o.activities.order(starts: :desc))
      zone_ids = zone_ids | o.zones.ids
      actions_ids = actions_ids | o.operations.ids
      #logger.debug org.inspect
      @organizations.push org
    end
    Zone.find(zone_ids).each do |z|
      @zones[z.id] = z
    end
    Subject.all.each do |z|
      @subjects[z.id] = {
        name: z.name,
        icon: z.icon.attached? ? url_for(z.icon) : '/images/icon_default.svg'
      }
    end
    logger.info("\n SUBJECTSS: \n#{subjs_ids}\n\n")
    Operation.find(actions_ids).each do |z|
      @actions[z.id] = {
        name: z.name,
        icon: z.icon.attached? ? url_for(z.icon) : '/images/icon_default.svg'
      }
    end
    logger.info("\n ACTIONS: \n#{@actions}\n\n")
    @showing = orgs.count
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end
end
