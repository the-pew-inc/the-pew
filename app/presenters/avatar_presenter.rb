class AvatarPresenter
  include ActionView::Context
  include ActionView::Helpers::AssetTagHelper

  def self.call(user, size = 8, font_size = 14)
    new(user, size, font_size).call
  end
  
  attr_accessor :user
  def initialize(user, size, font_size)
    @user = user
    @size = size
    @font_size = font_size
  end

  def call
    if gravatar_exists?
      gravatar_image
    else
      initials_element
    end
  end

  private

  def gravatar_exists?
    hash = Digest::MD5.hexdigest(email)
    http = Net::HTTP.new('www.gravatar.com', 80)
    http.read_timeout = 2
    response = http.request_head("/avatar/#{hash}?default=http://gravatar.com/avatar")
    response.code != '302' ? true : false
  rescue StandardError, Timeout::Error
    false
  end

  def gravatar_image
    gravatar_id = Digest::MD5.hexdigest(email)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"

    image_tag(gravatar_url, alt: nickname, class: "rounded-full flex flex-shrink-0 h-#{@size} w-#{@size}")
  end

  def initials_element
    style = "background-color: #{avatar_color(initials.first)};"
    font_style = "font-size: #{@font_size}px;"
    
    content_tag :div, class: "rounded-full flex flex-shrink-0 items-center justify-center w-#{@size} h-#{@size}", style: style do
      content_tag :div, initials, class: "font-mono font-bold text-gray-100", style: font_style
    end
  end

  def email
    user.email
  end

  def nickname
    user.profile&.nickname || "👻"
  end

  def initials
    nickname.split.first(2).map(&:first).join
  end

  # Return a color based on the first letter of the initials
  def avatar_color(initials)
    colors = [
      '#00AA55', '#009FD4', '#B381B3', '#939393', '#E3BC00',
      '#D47500', '#DC2A2A', '#696969', '#ff0000', '#ff80ed',
      '#407294', '#133337', '#065535', '#c0c0c0', '#5ac18e',
      '#666666', '#f7347a', '#576675', '#696966', '#008080',
      '#ffa500', '#40e0d0', '#0000ff', '#003366', '#fa8072',
      '#800000'
    ]

    colors[initials.first.to_s.downcase.ord - 97] || '#696969'
  end

end