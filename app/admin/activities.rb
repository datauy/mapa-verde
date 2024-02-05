ActiveAdmin.register Activity do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :title, :description, :image, :address, :starts, :ends, zone_ids: [], subject_ids: [], operation_ids: [], organization_ids: []
  #
  # or
  #
  # permit_params do
  #   permitted = [:title, :description, :address, :state, :municipality, :start, :end]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
  form :html => { :multipart => true } do |f|
    f.inputs do
      f.input :title
      f.input :description
      f.input :image, as: :file
      if f.object.image.attached?
        li do
          div do
            Rails.logger.debug "\n\nACTIVITY IMAGE ATTACHED: \n #{image_tag f.object.image} \n" 
            image_tag f.object.image
            #a "Borrar", href: delete_image_admin_activity_path, method: :delete, "data-confirm": "Confirme que desea eliminarla"
          end
          div do
            a "Borrar", href: delete_image_admin_activity_path, method: :delete, "data-confirm": "Confirme que desea eliminarla"
          end
        end
      end
      f.input :organizations, as: :searchable_select
      f.input :address
      f.input :zones, as: :check_boxes, nested_set: true, parent: "zone[zone_ids][]", parent_ids: resource.zone_ids, collection: Zone.where(ztype: 1)
      f.input :starts, as: :date_time_picker
      f.input :ends, as: :date_time_picker
      f.input :subjects, as: :searchable_select, input_html: { multiple: true }, label: "Otras actividades"
      f.input :operations, as: :searchable_select, input_html: { multiple: true }, label: "Acciones"
    end
    f.actions
  end

  member_action :delete_image, method: [:delete, :get] do
    if resource.image.attached?
      resource.image.delete
    end
    puts "\n\nPASA MEMBER DELETE image\n\n"
    redirect_to edit_resource_path, notice: "Imagen borrada"
  end
end
