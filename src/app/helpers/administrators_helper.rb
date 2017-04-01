module AdministratorsHelper
  # Returns the Gravatar for the given user.
  def gravatar_for(administrator, options = {size: 80})
    gravatar_id = Digest::MD5::hexdigest(administrator.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: administrator.name, class: "gravatar")
  end

end
