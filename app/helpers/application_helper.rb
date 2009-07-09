# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def viewing_gallery?(gallery)
    gallery_related? and 
    (
      current_page?(:id => gallery.id) or 
      current_page?(:gallery_id => gallery.id) 
    )
  end
  
  def gallery_related?
    request.request_uri.match /\/galleries\//i or
    request.request_uri.match /^\/$/ # map.root or root_path
  end
  
end
