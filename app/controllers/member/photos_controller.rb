class Member::PhotosController < MemberController
  before_action :set_imageable

  def index
    render json: @imageable.photos.collect { |photo| photo.to_jq_upload }.to_json
  end

  def create
    if @imageable.over_quota?
      render json: { error: 'You have reached the max number of photo'}, status: :bad_request
    else
      @photo = @imageable.photos.build(filter_params)
      if @photo.save
        render json: to_jq_upload(@photo)
      else
        render json: { error: 'Could not be saved the image' }, status: :bad_request
      end
    end
  end

  def destroy
    @photo = @imageable.photos.find_by(id: params[:id])
    @photo.destroy
    head :ok
  end

  def reposition
    ActiveRecord::Base.transaction do
      params[:photos].each_with_index do |photo_id, index|
        photo = Photo.update(photo_id, pos: index)
      end
    end
    render json:  @imageable.photos.find(params[:photos]).map(&:id)
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