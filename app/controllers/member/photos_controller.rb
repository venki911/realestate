class Member::PhotosController < MemberController
  before_action :set_imageable

  def index
    render json: @imageable.photos.collect { |photo| photo.to_jq_upload }.to_json
  end

  def create
    @photo = @imageable.photos.build(filter_params)
    if @photo.save
      render json: to_jq_upload(@photo)
    else
      render json: [ error: 'custom_failure'], status: 304
    end
  end

  def destroy
    begin
      @photo = @imageable.photos.find(params[:id])
      @photo.destroy
      redirect_to edit_member_property_path(@imageable), notice: 'Image has been removed'
    rescue
      redirect_to edit_member_property_path(@imageable), alert: 'Failed not removed the image, please retry'
    end
  end

  def reposition
    imageables = @imageable.photos.find(params[:photos])
    ActiveRecord::Base.transaction do
      params[:photos].each_with_index do |imageable_id, index|
        @imageable.photos.update(imageable_id, pos: index)
      end
    end
    
    head :ok
  end


  private
  def set_imageable
    klass = [Property].detect{|imageable| params["#{imageable.name.underscore}_id"]}
    @imageable = klass.find(params["#{klass.name.underscore}_id"])
  end

  def filter_params
    params.require(:photo).permit(:image_name, :property_id, :pos)
  end

  def to_jq_upload photo
    { id: photo.id,
      size: photo.image_name.size,
      url: photo.image_name.url,
      thumb_url: photo.image_name.thumb.url,
      medium_url: photo.image_name.medium.url,
      delete_url: member_property_photo_url(@imageable, photo)
    }.to_json
  end

end