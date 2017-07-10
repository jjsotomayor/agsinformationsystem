# frozen_string_literal: true

module IconsHelper

  def icon_true_false(boolean, size = 20)
    # image_tag(post.image.tiny.url)
    if boolean.nil?
      return
    elsif boolean
      return image_tag 'ticket_128.png', height: size, width: size
    else
      return image_tag 'red_cross.png', height: size, width: size
    end
  end
end
