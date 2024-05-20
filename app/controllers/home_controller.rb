class HomeController < ApplicationController
  def index
    @otype_options = Organization.where(enabled: true).includes(:organization_type).where.not('organization_types.id': nil).distinct.pluck(:'organization_types.name', :'organization_types.id')
    @zone_options = Organization.where(enabled: true).includes(:zones).where.not(zones: nil).distinct.pluck(:'zones.name', :'zones.id')
    @subject_options = Organization.where(enabled: true).includes(:subjects).where.not('subjects.id': nil).distinct.pluck(:'subjects.name', :'subjects.id')
    @action_options = Organization.where(enabled: true).includes(:operations).where.not('operations.id': nil).distinct.pluck(:'operations.name', :'operations.id')
    @total = Organization.where(enabled: true).count
    #self.search
  end
  def search
    @total = Organization.where(enabled: true).count
    @organizations = []
    zone_ids = []
    subjs_ids = []
    actions_ids = []
    @zones = {}
    @subjects = {}
    @actions = {}
    orgs = Organization.includes(:organization_type).where(enabled: true)
    if params['otypes'].present?
      orgs = orgs.where(organization_type: params['otypes'].split(','))
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
    if params['subjects'].present?
      subs = params['subjects'].split(',')
      orgs2 = orgs.dup
      orgs = orgs.where(subject_id: subs).order!(:name)
      orgs += orgs2.joins(:subjects).where(subjects: subs).order!(:name)
    end
    if !orgs.kind_of?(Array)
      orgs.order!(:name)
    end
    orgs.each do |o|
      org = o.as_json
      org.merge!(zones: o.zones.ids)
      org.merge!(subjects: o.subjects.ids)
      org.merge!(actions: o.operations.ids)
      org.merge!(organization_type: o.organization_type.name)
      org.merge!(logo: o.logo.attached? ? url_for(o.logo) : '/images/logo_mapa_verde.svg')
      org.merge!(activities: o.activities.where(enabled: true).order(starts: :desc))
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
        icon: z.icon.attached? ? url_for(z.icon) : '/images/icon_default.svg',
        color: z.color.present? ? z.color : '#00786C'
      }
    end
    Operation.find(actions_ids).each do |z|
      @actions[z.id] = {
        name: z.name,
        icon: z.icon.attached? ? url_for(z.icon) : '/images/icon_default.svg'
      }
    end
    @showing = orgs.count
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end
end
