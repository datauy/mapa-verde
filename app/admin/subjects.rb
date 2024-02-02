ActiveAdmin.register Subject do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :icon
  #
  # or
  #
  # permit_params do
  #   permitted = [:name]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  form :html => { :multipart => true } do |f|
    f.inputs do
      f.input :name
      f.input :icon, as: :file
      if f.object.icon.attached?
        logger.info "\n\nPASA FORM DELETE\n\n"
        span image_tag(f.object.icon)
          a "Borrar", href: delete_image_admin_subject_path(image_id: f.object.icon.id), "data-confirm": "Confirme que desea eliminarla"
      end
    end
    f.actions
  end

  index do
    selectable_column
    id_column
    column :name
    column :icon do |l|
      image_tag(l.icon) if l.icon.attached?
    end
    actions
  end

  member_action :delete_image, method: :get do
    if resource.icon.attached?
      resource.icon.delete
    end
    #@pic = ActiveStorage::Attachment.find(params[:id])
    #@pic.purge_later
    logger.info "\n\nPASA MEMBER DELETE\n\n"
    redirect_to collection_path, notice: "Imagen borrada"
  end
end
