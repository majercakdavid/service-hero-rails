module DashboardsHelper
  # Returns the Gravatar for the given user.
  def gravatar_for(user, options = {size: 80})
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.role.name, class: "gravatar")
  end

  def most_profitable_businesses
    Business.select("businesses.name, sum(business_services.price)")
        .joins("JOIN business_services ON business_services.business_id = businesses.id")
        .joins("JOIN business_service_orders ON business_service_orders.business_service_id = business_services.id")
        .group("businesses.name").limit(5)
  end
end
