module ApplicationHelper
  def howitworks_path
    homepage_anchor_path('howitworks')
  end

  def getrecommendations_path
    homepage_anchor_path('getrecommendations')
  end

  private

  def homepage_anchor_path(target)
    params[:controller] == 'requests' && params[:action] == 'new' ? "##{target}" : root_path(anchor: target)
  end
end
