module UsersHelper

  def bonus_button_text(bonus_type)
    case bonus_type.name
      when "HoleShot"
        'Main Event Holeshot'
      else
        "#{bonus_type.to_s}"
    end    
  end
end
