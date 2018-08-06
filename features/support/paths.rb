def path_to(page_name)
  case page_name
  
  when /the home page/
    root_path
  when /the sign in page/
    new_user_session_path
  when /the sign up page/
    new_user_registration_path
  when /the sign out page/
    destroy_user_session_path
  when /password retrieval/
    new_user_password_path
  when /rails admin/
    rails_admin_path
  when /my profile page/
    user_path(User.first)
  when /the teams page/
    teams_path
  when /the series page/
    series_index_path
  when /the custom series page/
    custom_series_index_path
  when /the leaderboards page/
    leaderboards_path
  when /settings/
    edit_user_registration_path(User.first)
  
  else
    raise "Can't find mapping from \"#{page_name}\" to a path."
  end
end
