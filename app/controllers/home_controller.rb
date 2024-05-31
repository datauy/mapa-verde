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
    orgs = Organization.where(enabled: true)
    if params['text'].present?
      orgs_init = orgs.includes(:subjects).includes(:operations).includes(:organization_type).includes(:zones)
      orgs = orgs_init.where("lower(organizations.name) like :value or lower(organizations.description) like :value or lower(organizations.volunteers_description) like :value", value: "%#{params['text'].strip.downcase}%")
      #Search text in taxonomies
      #Subjects
      op = Subject.where("lower(name) like :value", value: "%#{params['text'].strip.downcase}%")
      if op.length > 0
        #orgs.includes(:subjects)
        #orgs2 = orgs.dup
        orgs = orgs.or(orgs_init.where('subjects.id': op.ids))
      end
      #Actions
      op = Operation.where("lower(name) like :value", value: "%#{params['text'].strip.downcase}%")
      if op.length > 0
        #orgs.includes(:operations)
        #orgs2 = orgs.dup
        orgs = orgs.or(orgs_init.where('operations.id': op.ids))
      end
      #Actions
      op = OrganizationType.where("lower(name) like :value", value: "%#{params['text'].strip.downcase}%")
      if op.length > 0
        #orgs.includes(:organization_types)
        #orgs2 = orgs.dup
        orgs = orgs.or(orgs_init.where('organization_types.id': op.ids))
      end
      #Actions
      op = Zone.where("lower(name) like :value", value: "%#{params['text'].strip.downcase}%")
      if op.length > 0
        logger.debug "\n\nENTRA A ZONES\n#{op.ids}\n\n"
        #orgs.includes(:zones)
        #orgs2 = orgs.dup
        orgs = orgs.or(orgs_init.where('zones.id': op.ids))
      end
    end
    if params['otypes'].present?
      orgs = orgs.where(organization_type: params['otypes'].split(','))
    end
    if params['actions'].present?
      orgs = orgs.joins(:operations).where(operations: params['actions'].split(','))
    end
    if params['zones'].present?
      orgs = orgs.joins(:zones).where(zones: params['zones'].split(','))
    end
    if params['subjects'].present?
      subs = params['subjects'].split(',')
      orgs2 = orgs.dup
      orgs = orgs.where(subject_id: subs)
      orgs_ids = orgs.ids
      orgs = orgs.order!(:name)
      orgs += orgs2.joins(:subjects).where(subjects: subs).where.not(id: orgs_ids).distinct.order!(:name)
    end
    if !orgs.kind_of?(Array)
      orgs.distinct.order!(:name)
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
