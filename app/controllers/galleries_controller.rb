class GalleriesController < ApplicationController
  
  cache_sweeper :gallery_sweeper, :only => [ :create, :update, :destroy, :reorder ]
  before_filter :login_required, :except => [ :index, :show ]
  
  # GET /galleries
  # GET /galleries.xml
  def index
    @galleries = Gallery.ordered

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @galleries }
    end
  end

  # GET /galleries/1
  # GET /galleries/1.xml
  def show
    # map.root points to this action without providing an id
    @gallery = (params[:id]) ? Gallery.find(params[:id]) : Gallery.ordered.first
    @categories = @gallery.categories.ordered.find(:all, :include => :artworks)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @gallery }
    end
  end

  # GET /galleries/new
  # GET /galleries/new.xml
  def new
    @gallery = Gallery.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @gallery }
    end
  end

  # GET /galleries/1/edit
  def edit
    @gallery = Gallery.find(params[:id])
    @category = Category.new
  end

  # POST /galleries
  # POST /galleries.xml
  def create
    @gallery = Gallery.new(params[:gallery])

    respond_to do |format|
      if @gallery.save
        flash[:notice] = 'Gallery was successfully created.'
        format.html { redirect_to(@gallery) }
        format.xml  { render :xml => @gallery, :status => :created, :location => @gallery }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @gallery.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /galleries/1
  # PUT /galleries/1.xml
  def update
    @gallery = Gallery.find(params[:id])

    respond_to do |format|
      if @gallery.update_attributes(params[:gallery])
        flash[:notice] = 'Gallery was successfully updated.'
        format.html { redirect_to(@gallery) } # should this redirect back to edit instead? since this is only called when it's renamed
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @gallery.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /galleries/1
  # DELETE /galleries/1.xml
  def destroy
    @gallery = Gallery.find(params[:id])
    @gallery.destroy

    respond_to do |format|
      format.html { redirect_to( new_gallery_path ) }
      format.xml  { head :ok }
    end
  end
  
  # POST /galleries/reorder
  # AJAX
  def reorder
    galleries = params[:galleries]
    
    success = false
    Gallery.transaction do
      for i in 0...galleries.size do
        Gallery.find( galleries[i] ).update_attribute(:sequence, i + 1)
      end
      success = true
    end
    
    render :update do |page|
      if success
        flash[:notice] = "Reordered galleries"
        page[:flash].replace :partial => 'layouts/flash', :locals => { :flash => flash }
        page[:flash_notice].show
        page[:flash_notice].visual_effect :highlight
        page[:flash_notice].visual_effect :fade, :duration => 3
        flash.clear
      else
        flash[:error] = "Could not reorder galleries"
        page[:flash].replace :partial => 'layouts/flash', :locals => { :flash => flash }
        page[:flash_error].show
        page[:flash_error].visual_effect :highlight
        page[:flash_error].visual_effect :fade, :duration => 3
        flash.clear
      end
    end
  end
  
end
