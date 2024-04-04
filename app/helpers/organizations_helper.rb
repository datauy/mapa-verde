module OrganizationsHelper
  def zone_search_options(query)
    opts = []
    query.each do |z|
      if z.parent_zone_id.present?
        opts << ["#{z.name}, #{z.parent_zone.name} - #{z.ztype}", z.id]
      else
        opts << ["#{z.name} - #{z.ztype}", z.id]
      end
    end
    opts
  end
end
