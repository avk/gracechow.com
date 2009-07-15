class ArtworksController < ApplicationController
  
  before_filter :get_gallery
  
  # GET /artworks/1
  def show
    @artwork = Artwork.find(params[:id])
    
    all = @artwork.category.artworks
    @sequence = all.index(@artwork) + 1
    @size = all.size
    
    @prev_artwork = Artwork.before(@artwork)
    @next_artwork = Artwork.after(@artwork)

    respond_to do |format|
      format.js { render :partial => 'show' }
    end
  end

  # GET /artworks/new
  def new
    @artwork = Artwork.new
    @categories = @gallery.categories
    if params[:category_id]
      @artwork.category = @categories.find(params[:category_id])
    end

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /artworks/1/edit
  def edit
    @artwork = Artwork.find(params[:id])
  end

  # POST /artworks
  def create
    @artwork = Artwork.new(params[:artwork])
    @categories = @gallery.categories

    respond_to do |format|
      if @artwork.save
        flash[:notice] = 'Artwork was successfully created.'
        format.html { redirect_to(@gallery) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /artworks/1
  def update
    @artwork = Artwork.find(params[:id])

    respond_to do |format|
      if @artwork.update_attributes(params[:artwork])
        flash[:notice] = 'Artwork was successfully updated.'
        format.html { redirect_to(@artwork) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /artworks/1
  def destroy
    @artwork = Artwork.find(params[:id])
    @artwork.destroy

    respond_to do |format|
      format.html { redirect_to(artworks_url) }
    end
  end
  
protected

  def get_gallery
    @gallery = Gallery.find(params[:gallery_id])
  end
  
end
