Then(/^Pause$/) do
  pause
end

AfterStep('@pause') do
  pause
end

def pause
  print "Press Return to continue"
  STDIN.getc
end
