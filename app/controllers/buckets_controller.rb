class BucketsController < ApplicationController
  api :GET, '/buckets/:bucket_id', 'Full details of bucket'
  def show
    respond_with bucket
  end

  api :POST, '/buckets/', 'Create a bucket'
  def create
    create_resource(bucket_params_create)
  end

  api :PUT, '/buckets/:bucket_id', 'Update a bucket'
  def update
    update_resource(bucket_params_update)
  end

  private
    def bucket
      @bucket ||= Bucket.find(params[:id])
    end

    def bucket_params_create
      params.require(:bucket).permit(:name,
                                     :description,
                                     :round_id,
                                     :user_id,
                                     :target_cents)
    end

    def bucket_params_update
      params.require(:bucket).permit(:name,
                                     :description,
                                     :user_id,
                                     :target_cents)
    end
end
