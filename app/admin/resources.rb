ActiveAdmin.register Resource do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :title, :description, :link, :summary, :weight, subject_ids:[]
  #
  # or
  #
  # permit_params do
  #   permitted = [:title, :description, :link]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  form do |f|
    f.inputs do
      f.input :title
      f.input :summary, as: :ckeditor
      f.input :description, as: :ckeditor
      f.input :subjects
      f.input :link
      f.input :weight
    end
    f.actions
  end
  #
  #
  #
  index do
    selectable_column
    id_column
    column :title
    column :summary
    column :description
    column :subjects
    column :link
    column :weight
    column :created_at
    actions
  end
end
