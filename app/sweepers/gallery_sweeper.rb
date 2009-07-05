class GallerySweeper < ActionController::Caching::Sweeper
  observe Gallery
  
  def after_create(gallery)
    expire_fragment "navigation"
  end
  
  def after_update(gallery)
    expire_fragment "navigation"
  end
  
  def after_destroy(gallery)
    expire_fragment "navigation"
  end
  
end