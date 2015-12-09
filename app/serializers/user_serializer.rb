class UserSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id,
             :name,
             :email,
             :utc_offset,
             :subscribed_to_personal_activity,
             :subscribed_to_daily_digest,
             :subscribed_to_participant_activity,
             :is_pending_confirmation

  def is_pending_confirmation
    !object.has_set_up_account?
  end
end
