class BucketAllocationsController < ApplicationController
  inherit_resources

  belongs_to :allocator
  load_and_authorize_resource :allocator

  api :GET, '/buckets/:bucket_id/allocators/:allocator_id/allocation.json', 'Show me my allocation for this bucket'
  def show
    @bucket = Bucket.find(params[:bucket_id])

    @allocation = @allocator.allocations.where(bucket: @bucket).first
    authorize! :show, @allocation
    respond_with @allocation
  end

end