class BucketsController < AuthenticatedController
  api :GET, '/buckets/:id', 'Full details of bucket'
  def show
    respond_with resource
  end

  api :POST, '/buckets', 'Create a bucket'
  def create
    create_resource(bucket_params_create)
  end

  api :PUT, '/buckets/:id', 'Update a bucket'
  def update
    update_resource(bucket_params_update)
  end

  api :DELETE, '/buckets/:id', 'Deletes a bucket'
  def destroy
    destroy_resource
  end

  private
    def bucket_params_create
      params.require(:bucket).permit(:name,
                                     :description,
                                     :group_id,
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
