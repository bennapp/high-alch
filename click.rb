require 'rumouse'

def click_with_variance
  mouse_click(alc_location)
  sleep_variance
end

def double_click_with_variance
  click_with_variance
  click_with_variance
  double_click_wait
end

def double_click_wait
  sleep 2
  3.times { sleep_variance } if rand(8) == 0
end

def sleep_variance
  variance = rand(25) / 100.to_f
  sleep variance
end

def high_alch(time = 1)
  time = time.to_i
  puts "alching #{time} time(s)"

  click_magic_bag

  time.times do |num|
    if moved_mouse?
      pause_with_remaining(time - num)
      return
    end

    double_click_with_variance
  end

  high_alch_more?(time)
end

def high_alch_more?(time)
  puts "Finished alching #{time} time(s). Enter number of times to continue high alching."
  puts "press Ctrl+Z(windows) or Ctrl+D(unix) and then Enter to continue alching"
  num = $stdin.read
  high_alch(num)
end

def click_magic_bag
  x = 24
  y = -146
  magic_bag_x = alc_location[0] + x
  magic_bag_y = alc_location[1] + y

  mouse_click([magic_bag_x, magic_bag_y])
  sleep_variance
end

def moved_mouse?
  diff_x, diff_y = distance_from_current_position
  diff_x > move_away_threashold || diff_y > move_away_threashold
end

def move_away_threashold
  500
end

def mouse_back?
  diff_x, diff_y = distance_from_current_position
  diff_x < move_back_threashold && diff_y < move_back_threashold
end

def move_back_threashold
  70
end

def distance_from_current_position
  current_position = @mouse.position
  diff_x = (current_position[:x] - @location[:x]).abs
  diff_y = (current_position[:y] - @location[:y]).abs

  [diff_x, diff_y]
end

def pause_with_remaining(num)
  puts "Interrupted, put mouse back to high alch spell location to continue alching #{num} time(s)"
  loop do
    break if mouse_back?
    sleep 1
  end
  high_alch(num)
end

def alc_location
  [@location[:x], @location[:y]]
end

def mouse_click(location)
  @mouse.click(*location)
end

def mouse_move(location)
  @mouse.move(*location)
end

def track_location
  puts "Move mouse to hover over high alch spell"
  start_time = Time.now
  @location = nil

  loop do
    @location = @mouse.position
    puts @location
    break if Time.now - start_time > 3
    sleep 0.5
  end

  puts "finished tracking at #{@location}"
end

@mouse = RuMouse.new
track_location
high_alch ARGV[0]


{'green d' =>  '4401',
'blue d' => '5390',
'add plate' => '9620',
'rune axe' => '7401',
'red d' => '6501',
'back d' => '7720',
'rune d' => '4551'}
