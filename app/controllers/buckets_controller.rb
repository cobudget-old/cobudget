class BucketsController < ApplicationController
  api :GET, '/buckets/:bucket_id', 'Full details of bucket'
  def show
    respond_with bucket
  end

  private
    def bucket
      @bucket ||= Bucket.find(params[:id])
    end
end
