module DashboardsHelper
  # Returns the Gravatar for the given user.
  def gravatar_for(user, options = {size: 80, class: '', styles: ''})
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.role.name, class: "gravatar #{options[:class]}", style: options[:styles])
  end

  def show_svg(path)
    File.open("app/assets/images/#{path}", "rb") do |file|
      raw file.read
    end
  end
end
