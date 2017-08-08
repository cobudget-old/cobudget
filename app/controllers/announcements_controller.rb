class AnnouncementsController < AuthenticatedController
  api :GET, '/announcements', 'Get a list of Announcements for this user'
  def index
    render json: Announcement.tracked(current_user)
  end

  api :POST, '/announcements/seen', 'Mark announcements as read'
  def seen
    tracker = AnnouncementTracker.find_or_create_by(user_id: current_user.id)
    tracker.update_attributes({last_seen: params.require(:last_seen)})
    if tracker.save
      render json: [tracker]
    else
      render json: {errors: tracker.error.full_messages}, status: 400
    end
  end

end
