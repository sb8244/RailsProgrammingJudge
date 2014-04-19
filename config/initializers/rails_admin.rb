RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  config.authorize_with do |controller|
    redirect_to main_app.root_path, error: "Please sign in as admin" unless current_user && current_user.admin?
  end

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    bulk_delete
    show
    edit
    delete
    show_in_app
  end

  config.model Problem do
    edit do
      configure :html, :wysihtml5
      configure :input_example, :code_mirror
      configure :output_example, :code_mirror
    end
  end

  config.model TestCase do
    edit do
      configure :input, :code_mirror
      configure :output, :code_mirror
    end
  end
end
