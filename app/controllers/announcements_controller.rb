class AnnouncementsController < AuthenticatedController
  api :GET, '/announcements', 'Get a list of Announcements for this user'
  def index
    render json: Announcement.tracked(current_user)
  end

  api :POST, '/announcements/seen', 'Mark announcements as read'
  def seen
    # this is where we add the tracking information
    render json: Announcement.all
  end

end
