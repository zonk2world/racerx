#!/usr/bin/env ruby

# Usage
# ./deploy [review|production] <options>
#
# Options
# -m or --maintenance - Put the application into maintenance mode
# -s or --seed - enable db seeding

if ['review', 'production'].include? ARGV[0]
  puts "fetching code from 12spokes..."
  `git fetch origin`

  remote = ARGV[0]
  maintenance = ARGV.include?('-m') || ARGV.include?('--maintenance')
  sync_review = ARGV.include?('--sync') || ARGV.include?('-s')
  seed = ARGV.include?('--seed')
  branch = "master"
  alt_branch = ARGV.index('-b') || ARGV.index('--branch')
  repo = 'git@github.com:12spokes/motodynasty.git'
  revision=`git rev-parse master`
  production = 'motodynasty'
  staging = 'motodynasty-review'
  
  case remote
    when 'review'
      app = 'motodynasty-review'
      airbrake_env = 'review'
    when 'production'
      app = 'motodynasty'
      airbrake_env = 'production'
  end
    
  if maintenance
    puts 'putting app into maintenance mode'
    `heroku maintenance:on --app #{app}`
  end
  
  if alt_branch
    branch = ARGV[alt_branch.to_i + 1]
  end

  puts "pushing code from #{branch}..."

  `git push -f #{remote} #{branch}:master`

  if sync_review || app == production
    puts "backing up production database..."
    `heroku pgbackups:capture --app #{production} --expire`
  end

  if sync_review
    puts "syncing review with production..."
    `heroku pgbackups:restore DATABASE \`heroku pgbackups:url --app #{production}\` --app #{staging} --confirm #{staging}`
  end
    
  puts "migrating database..."
  puts `heroku run rake db:migrate --app #{app}`
  
  if seed
    puts "seeding database..."
    puts `heroku run rake db:seed --app #{app}`
  end
  
  if maintenance
    puts 'bringin app back out of maintenance mode...'
    `heroku maintenance:off --app #{app}`
  end
  
  puts "notifying airbrake (rake airbrake:deploy TO=#{airbrake_env} REVISION=#{revision} REPO=#{repo})"
  `bundle exec rake airbrake:deploy TO=#{airbrake_env} REVISION=#{revision} REPO=#{repo}`
  
  puts '.....done. Celebrate!'
else
  puts "You must specify review or production"
end
