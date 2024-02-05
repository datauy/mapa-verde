ActiveAdmin.register Organization do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :otype, :subject_id, :description, :website, :phone, :whatsapp, :email, :instagram, :tiktok, :twitter, :facebook, :snapchat, :other_network, :address, :state, :region, :zone, :volunteers_description, :volunteers_url, :donations, :logo, zone_ids: [], subject_ids: [], operation_ids: []
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :otype, :subject_id, :description, :website, :phone, :whatsapp, :email, :instagram, :tiktok, :twitter, :facebook, :snapchat, :other_network, :address, :state, :region, :zone, :volunteers_description, :volunteers_url, :donations]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
  form :html => { :multipart => true } do |f|
    f.inputs do
      f.input :name
      f.input :otype
      f.input :logo, as: :file
      if f.object.logo.attached?
        li do
          div do
            image_tag(f.object.logo)
          end
          div do
            a "Borrar", href: delete_image_admin_organization_path, method: :delete, "data-confirm": "Confirme que desea eliminarla"
          end
        end
      end
      f.input :subject, as: :searchable_select, label: "Actividad principal"
      f.input :subjects, as: :searchable_select, input_html: { multiple: true }, label: "Otras actividades"
      f.input :operations, as: :searchable_select, input_html: { multiple: true }, label: "Acciones"
      f.input :description, as: :ckeditor
      f.input :website
      f.input :phone
      f.input :whatsapp
      f.input :email
      f.input :instagram
      f.input :tiktok
      f.input :twitter
      f.input :facebook
      f.input :snapchat
      f.input :other_network
      f.input :address
      f.input :region
      f.input :zones, as: :check_boxes, nested_set: true, parent: "organization[zone_ids][]", parent_ids: resource.zone_ids, collection: Zone.where(ztype: 1)
      f.input :volunteers_description, as: :ckeditor
      f.input :volunteers_url
      f.input :donations
    end
    f.actions
  end
  member_action :delete_image, method: [:delete, :get] do
    if resource.logo.attached?
      resource.logo.delete
    end
    puts "\n\nPASA MEMBER DELETE\n\n"
    redirect_to edit_resource_path, notice: "Imagen borrada"
  end

  before_save do |object|
    #params[:organization][:zone_ids].reject! { |c| c.empty? }
    #params[:organization][:subject_ids].reject! { |c| c.empty? }
    #params[:organization][:operation_ids].reject! { |c| c.empty? }
    logger.debug "\nBEFORE SAVE RESOURCE\n #{params[:organization]}\n\n"

    #super
  end
end
