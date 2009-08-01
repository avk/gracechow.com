class ArtworksController < ApplicationController
  
  before_filter :get_gallery
  in_place_edit_for :artwork, :title
  in_place_edit_for :artwork, :description
  skip_before_filter :verify_authenticity_token, :only => [ :set_artwork_title, :set_artwork_description ]
  
  # GET /artworks/1
  def show
    @artwork = Artwork.find(params[:id])
    
    all = @artwork.category.artworks.ordered
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
    @categories = @gallery.categories.ordered # FIXME: pull out into a before_filter
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
    @categories = @gallery.categories # FIXME: pull out into a before_filter

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
        format.html { redirect_to(@gallery) }
      else
        format.html { render :action => "edit" }
      end
    end
  end
  
  # in_place_editing method
  # POST /galleries/1/artworks/1/set_artwork_title
  def set_artwork_title
    @artwork = Artwork.find(params[:id])
    old_title = @artwork.title
    new_title = params[:value]
    @artwork.title = new_title
    
    respond_to do |wants|
      if @artwork.save
        wants.js { render :text => h(new_title) }
      else
        wants.js { render :text => h(old_title) }
      end
    end
  end
  
  # in_place_editing method
  # POST /galleries/1/artworks/1/set_artwork_description
  def set_artwork_description
    @artwork = Artwork.find(params[:id])
    @artwork.update_attribute(:description, params[:value])
    
    respond_to do |wants|
      desc = @artwork.description
      desc = '~' if desc.blank?
      wants.js { render :text => desc }
    end
  end
  
  # in_place_editing method
  # GET /galleries/1/artworks/1/textilized_description
  def textilized_description
    render :text => Artwork.find(params[:id]).description(:source)
  end
  
  

  # DELETE /artworks/1
  def destroy
    @artwork = Artwork.find(params[:id])

    respond_to do |format|
      if @artwork.destroy
        flash[:notice] = "Artwork deleted."
      else
        flash[:error] = "Could not delete artwork."
      end
      format.html { redirect_to gallery_path(@gallery) }
    end
  end

  # POST /galleries/1/artworks/reorder
  # AJAX
  def reorder
    artworks = params[ ("category_" + params[:category_id] + "_artworks").to_sym ]
    
    success = false
    Gallery.transaction do
      for i in 0...artworks.size do
        Artwork.find( artworks[i] ).update_attribute(:sequence, i + 1)
      end
      success = true
    end
    
    render :update do |page|
      if success
        flash[:notice] = "Reordered artworks"
        page[:flash].replace :partial => 'layouts/flash', :locals => { :flash => flash }
        page[:flash_notice].show
        page[:flash_notice].visual_effect :highlight
        page[:flash_notice].visual_effect :fade, :duration => 3
        flash.clear
      else
        flash[:error] = "Could not reorder artworks"
        page[:flash].replace :partial => 'layouts/flash', :locals => { :flash => flash }
        page[:flash_error].show
        page[:flash_error].visual_effect :highlight
        page[:flash_error].visual_effect :fade, :duration => 3
        flash.clear
      end
    end
  end

  
protected

  def get_gallery
    @gallery = Gallery.find(params[:gallery_id])
  end
  
end
