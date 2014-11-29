class BucketsController < ApplicationController
  api :GET, '/buckets/:bucket_id', 'Full details of bucket'
  def show
    respond_with bucket
  end

  api :POST, '/buckets/', 'Create a bucket'
  def create
    # TODO: make sure only group admins can create new buckets
    respond_with Bucket.create(bucket_params)
  end

  private
    def bucket
      @bucket ||= Bucket.find(params[:id])
    end

    def bucket_params
      params.require(:bucket).permit(:name,
                                     :description,
                                     :round_id,
                                     :user_id,
                                     :target_cents)
    end
end
