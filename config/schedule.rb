every :weekday, at: ['8:45 am', '8:47 am', '8:49 am', '8:51 am', '8:52 am', '8:53 am', '8:54 am', '8:55 am'] do
  command "/usr/bin/ruby ~/projects/where-is-my-bus/main.rb company"
end
every :weekday, at: ['6:30 pm', '6:35 pm', '6:40 pm', '6:45 pm', '6:50 pm'] do
  command "/usr/bin/ruby ~/projects/where-is-my-bus/main.rb home"
end