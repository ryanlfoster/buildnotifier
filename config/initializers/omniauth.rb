Rails.application.config.middleware.use OmniAuth::Builder do
  provider :identity,
    :fields => [:name, :email],
    :on_failed_registration => UsersController.action(:new),
    :form => UsersController.action(:new)
end
