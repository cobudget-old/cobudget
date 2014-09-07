class BucketAllocationsController < ApplicationController

  api :GET, '/buckets/:bucket_id/allocators/:allocator_id/allocation.json', 'Show me my allocation for this bucket'
  def show
    load_associations
    @allocation = resource
    authorize! :show, @allocation
    render json: @allocation
  end

  api :PUT, '/buckets/:bucket_id/allocators/:allocator_id/allocation.json', 'Create or update my allocation for this bucket'
  param :allocation, Hash, desc: "New allocation info" do
    param :amount_cents, Integer
  end
  def update
    load_associations
    @allocation = resource_or_new
    @allocation.update_attributes(allocation_params)
    render json: @allocation
  end

  private

  def load_associations
    @bucket = Bucket.find(params[:bucket_id])
    @allocator = Bucket.find(params[:allocator_id])
  end

  def scope
    @allocator.allocations.where(bucket: @bucket)
  end

  def resource
    scope.first
  end

  def resource_or_new
    resource || scope.build
  end

  def allocation_params
    params.require(:allocation).permit(:amount_cents)
  end

end