class BucketsController < ApplicationController
  respond_to :json

  api :GET, "/buckets", "Show all buckets"
  def index
    respond_with Bucket.all
  end
end