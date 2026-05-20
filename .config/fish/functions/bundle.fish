function be
  bundle exec $argv
end

function bu
  bundle update
end

function bi
  bundle install
end

function bubi
  bu; and bi
end

function ber
  be rspec $argv
end
