module ApplicationHelper
  def format_money(amount)
    number_to_currency((amount/100.0), unit: "$")
  end

  def format_datetime(datetime)
    return "" unless datetime
    "#{datetime.strftime("%b, %d %Y %I:%M %p")} (EST)"
  end

  def nav_class_for(link)
    @active_app_area == link ? "active" : ""
  end

  def settings_for(var)
    row = Setting.find_by(var: var)
    if row.present?
      row.value
    else
      nil
    end
  end
  def link_to_facebook(app)
    # <a href="http://www.facebook.com/sharer.php?&amp;p[summary]=Want to acquire an app? (i.e. ownership, users, IP, etc) you should check out Outlook Web Mobile (OWA Email) via @apptopia!&amp;p[title]=Outlook Web Mobile (OWA Email) is on sale&amp;p[url]=http://www.apptopia.com/listings/outlook-web-mobile-owa-email&amp;s=100" class="fb" target="_blank">Share on Facebook</a>
    address_facebook = "https://www.facebook.com/sharer/sharer.php?"
    title = "p[title]="

    desc = "&p[description]=MotoDynasty Service"
    images = "&p[images][]=#{root_url}/assets/logo.png"
    summary = "&p[summary]="
    url = "&p[url]=#{root_url}"    
    param_str = title + desc + images + summary + url + "&s=100"
    # facebook = content_tag :a, "<img src='/assets/social/facebook.png'>Share this job on facebook".html_safe, 
    #   :href => address_facebook + param_str, :target => '_blank'
    address_facebook + param_str
  end

  def link_to_twitter

    address_twitter = "https://twitter.com/share?"
    #text = "text=#{app.name} - #{app.description}" # very long
    text = "text="
    
    related = "&related=Apptopia"
    mini = "&mini=true"
    url = "&url=" + URI.encode("#{root_url}")
    param_str = text + url + related + mini
    address_twitter + param_str
  end

end
