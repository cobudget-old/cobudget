class AnnouncementsController < AuthenticatedController
  api :GET, '/announcements', 'Get a list of Announcements for this user'
  def index
    render json: Announcement.tracked(current_user)
  end

end
