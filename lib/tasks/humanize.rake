task :humanize => :environment do
  Player.all do |player|
    if player.username.include?("cp")
      player.update_attributes(:is_human => false)
    else
      player.update_attributes(:is_human? => true)
    end
  end
end