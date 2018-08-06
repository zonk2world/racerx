module Leaderboards::BaseHelper
  def breadcrumbs ancestors
    crumbs = []
    ancestors.each_with_index do |ancestor, i|
      crumbs << link_to(ancestor.to_s.titleize, url_for(ancestors[0..i]))
    end

    return <<-HTML.html_safe
      <ul class="breadcrumb">
        <li>#{crumbs.join("</li><li>")}</li>
      </ul>
    HTML
  end

  def sibling_nav_class current, sibling
    if current == sibling
      'active'
    else
      ''
    end
  end

  def prize_filter_button_class filter_by_eligible_prizes
    if filter_by_eligible_prizes
      'btn btn-warning prize-filter active'
    else
      'btn btn-primary prize-filter'
    end
  end

  def prize_filter_options(prize_filter)
    if prize_filter
      nil
    else
      { prize_filter: true }
    end
  end
end
