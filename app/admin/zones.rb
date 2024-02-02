ActiveAdmin.register Zone do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :ztype, :geometry, :parent_zone_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :ztype, :geometry]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  form do |f|
    f.inputs do
      f.input :name
      f.input :ztype
      f.input :geometry
      f.input :parent_zone, :as => :searchable_select, collection:  Zone.all.map{|s| ["#{s.name} - #{s.ztype}", s.id]}
    end
    f.actions
  end
end
