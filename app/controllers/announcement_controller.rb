class AnnouncementController < AuthenticatedController
  api :GET, '/announcements', 'Get a list of Announcements for this user'
  def index
    announcements = Announcements.all
    render json: announcements
  end
 
end
