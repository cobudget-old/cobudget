class AnnouncementsController < AuthenticatedController
  api :GET, '/announcements', 'Get a list of Announcements for this user'
  def index
    announcements = Announcement.all
    render json: announcements
  end

end
