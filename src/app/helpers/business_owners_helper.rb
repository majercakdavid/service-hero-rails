module BusinessOwnersHelper
  def get_businesses
    current_user.role.businesses
  end
end
