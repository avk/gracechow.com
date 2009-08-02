# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def viewing_gallery?(gallery)
    (home_page? and gallery.first?) or
    (gallery_related? and (current_page?(:id => gallery.id) or current_page?(:gallery_id => gallery.id)))
  end
  
  def gallery_related?
    request.request_uri.match /\/galleries\//i
  end
  
  def home_page?
    request.request_uri == '/' # map.root
  end
  
end
