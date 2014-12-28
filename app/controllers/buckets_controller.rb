class BucketsController < ApplicationController
  api :GET, '/buckets/:bucket_id', 'Full details of bucket'
  def show
    respond_with bucket
  end

  api :POST, '/buckets/', 'Create a bucket'
  def create
    respond_with create_resource(bucket_params)
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
