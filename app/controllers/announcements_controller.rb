class AnnouncementsController < AuthenticatedController
  api :GET, '/announcements', 'Get a list of Announcements for this user'
  def index
    render json: Announcement.tracked(current_user)
  end

  api :POST, '/announcements/seen', 'Mark announcements as read'
  def seen
    tracker = AnnouncementTracker.find(current_user.id)
    render status: 403, nothing: true and return unless tracker.is_editable_by?(current_user)
    tracker.update_attributes(params.require(:last_seen))
    if tracker.save
      render json: [tracker]
    else
      render json: {errors: tracker.error.full_messages}, status: 400
    end
  end

end
