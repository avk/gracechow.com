class CategoriesController < ApplicationController
  
  # POST /galleries/1/categories
  def create
    @gallery = Gallery.find(params[:gallery_id])
    @category = Category.new(params[:category])
    @category.gallery = @gallery
    
    respond_to do |format|
      if @category.save
        # flash[:notice] = 'Category was successfully created.'
        # format.html { redirect_to( edit_gallery_path(@gallery) ) }
        format.js do
          # flash.clear
          render :update do |page|
            page.insert_html :bottom, :gallery_categories, :partial => 'category', :locals => { :category => @category }
            page[:sortable_categories].reload
          end
        end
        
      else
        # format.html { redirect_to edit_gallery_path( params[:gallery_id] ) }
        format.js do
          render :update do |page|
            page.alert "Could not create category."
          end
        end
      end
      
    end
  end

  # PUT /galleries/1/categories/1
  def update
    @gallery = Gallery.find(params[:gallery_id])
    @category = @gallery.categories.find(params[:id])

    respond_to do |format|
      if @category.update_attributes(params[:category])
        # format.html { redirect_to(@gallery) }
        format.js do
          render :update do |page|
            page["category_#{@category.id}"].replace :partial => 'category', :locals => { :category => @category }
            page[:sortable_categories].reload
          end
        end
      else
        # format.html { render :action => "edit" }
        format.js do
          render :update do |page|
            page.alert "Could not update category."
          end
        end
      end
    end

  end

  # DELETE /galleries/1/categories/1
  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    
    respond_to do |format|
      # format.html { redirect_to( edit_gallery_path(@gallery) ) }
      format.js do
        render :update do |page|
          page["category_#{@category.id}".to_sym].remove
        end
      end
    end
  end

  # POST /galleries/1/categories/reorder
  # AJAX
  def reorder
    categories = params[:gallery_categories]
    
    success = false
    Category.transaction do
      for i in 0...categories.size do
        Category.find( categories[i] ).update_attribute(:sequence, i + 1)
      end
      success = true
    end
    
    render :update do |page|
      page.alert "Could not reorder categories" unless success
    end
  end
  
end
