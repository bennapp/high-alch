require 'rumouse'

def click_with_variance(location)
  mouse_click(location)
  sleep_variance
end

def double_click_with_variance(offset = 0)
  click_with_variance(alc_location)
  click_with_variance(location_from_offset(offset))
  double_click_wait
end

def double_click_wait
  sleep 2.8
end

def sleep_variance
  variance = rand(3) / 100.to_f
  fixed = 0.1
  sleep(variance + fixed)
end

def high_alch(time = 1, offset = 0, total = 0)
  time = time.to_i
  puts "alching #{time} time(s)"

  time.times do |num|
    rem = time - num

    if moved_mouse?
      pause_with_remaining(rem)
      print_time_remaining(total)
    end

    puts "remaining: #{rem}" if rem % 25 == 0

    click_magic_bag
    double_click_with_variance(offset)
    click_camelot if should_click_camelot?

    total -= 1
  end
end

def click_magic_bag
  x = 24
  y = -146
  magic_bag_x = alc_location[0] + x
  magic_bag_y = alc_location[1] + y

  mouse_click([magic_bag_x, magic_bag_y])
  sleep_variance
end

def click_camelot
  x = -26
  y = -30
  camelot_x = alc_location[0] + x
  camelot_y = alc_location[1] + y

  mouse_click([camelot_x, camelot_y])
  sleep 3
  sleep_variance
end

def should_click_camelot?
  @camelot
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
end

def alc_location(x = 0, y = 0)
  [(@location[:x] + x), (@location[:y] + y)]
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
    break if Time.now - start_time > 5
    sleep 0.5
  end

  puts "finished tracking at #{@location}"
end

def location_from_offset(offset)
  mapping = {
      3 => alc_location(0, -99),
      2 => alc_location(-50, -99),
      1 => alc_location(-90, -99),
      0 => alc_location(-130, -99),

      7 => alc_location(0, -66),
      6 => alc_location(-50, -66),
      5 => alc_location(-90, -66),
      4 => alc_location(-130, -66),
  }

  mapping[offset]
end

def print_time_remaining(total)
  puts "Estimated time: #{Time.at(total * 3).utc.strftime("%H:%M:%S")}"
end

total = ARGV.map(&:to_i).inject(&:+)
puts "Alching: #{total} item(s)"
print_time_remaining(total)

@camelot = false
@mouse = RuMouse.new
track_location

ARGV.map.with_index do |num, i|
  high_alch(num, i, total)
  total -= num.to_i
  print_time_remaining(total)
end

{
  'green d' =>  '4401',
  'blue d' => '5390',
  'red d' => '6501',
  'black d' => '7720',
  'rune d' => '4551',
  'rune axe' => '7401',
  'adamant plate' => '9580',
  'rune med' => '11202',
}
