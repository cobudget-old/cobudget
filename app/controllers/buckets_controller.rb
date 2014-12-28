class BucketsController < ApplicationController
  api :GET, '/buckets/:bucket_id', 'Full details of bucket'
  def show
    respond_with resource
  end

  api :POST, '/buckets/', 'Create a bucket'
  def create
    create_resource(bucket_params_create)
  end

  api :PUT, '/buckets/:bucket_id', 'Update a bucket'
  def update
    update_resource(bucket_params_update)
  end

  api :DELETE, '/buckets/:round_id', 'Deletes a bucket'
  def destroy
    destroy_resource
  end

  private
    def bucket_params_create
      params.require(:bucket).permit(:name,
                                     :description,
                                     :round_id,
                                     :user_id,
                                     :target)
    end

    def bucket_params_update
      params.require(:bucket).permit(:name,
                                     :description,
                                     :user_id,
                                     :target)
    end
end
