module StaticHelper
  def showIcon(percentage)
    if percentage >= 90
     image_tag("smile1.png", :alt => percentage.to_s+"% won", :width => "64px")
    elsif percentage >= 75 && percentage < 90
      image_tag("smile2.png", :alt => percentage.to_s+"% won", :width => "64px")
    elsif percentage >= 50 && percentage < 75
      image_tag("smile3.png", :alt => percentage.to_s+"% won", :width => "64px")
    elsif percentage >= 25 && percentage < 50
      image_tag("smile4.png", :alt => percentage.to_s+"% won", :width => "64px")
    else
      image_tag("smile5.png", :alt => percentage.to_s+"% won", :width => "64px")
    end
  end
end
