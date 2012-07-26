# lib/tasks/kill_postgres_connections.rake
task :kill_postgres_connections => :environment do
  db_name = "card_games_development"
  sh = <<EOF
ps xa \
  | grep postgres: \
  | grep #{db_name} \
  | grep -v grep \
  | awk '{print $1}' \
  | xargs kill
EOF
  puts `#{sh}`
end

task "drop_it_hard" => :kill_postgres_connections