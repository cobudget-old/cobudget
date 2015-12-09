module Helpers
  def parsed(response)
    JSON.parse(response.body)
  end
end
