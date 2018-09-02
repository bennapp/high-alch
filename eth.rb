require 'rumouse'

@mouse = RuMouse.new

def track_move(move)
  start_time = Time.now
  count_time = 5
  counter = count_time

  loop do
    location = @mouse.position
    puts "move: #{move} --- #{counter} --- tracking at: #{@location}"

    if Time.now - start_time > count_time
      puts "tracked #{move} at #{location}"
      return location
    end

    sleep 1
    counter -= 1
  end
end

def track_moves
  moves = [
      "right click banker",
      "click bank banker",
      "click eth",
      "click bracelet",
      "click x bank",
      "click inv",
      "click 1",
      "click 2",
      "click magic",
      "click high alc",
      "click 2",
  ]

  puts moves
  puts moves.map { |move| track_move(move) }
end

# every ten mins press right or left to adj camera

def eth_cycle
  locations = [
    {:x=>1725, :y=>662, :press=>2},
    {:x=>1722, :y=>704, :press=>1},
    {:x=>1563, :y=>852, :press=>1},
    # {:x=>1549, :y=>858, :press=>1},
    # {:x=>1658, :y=>341, :press=>1},
    # {:x=>1911, :y=>775, :press=>1},
    # {:x=>1850, :y=>819, :press=>1},
    # {:x=>1892, :y=>818, :press=>1},
    # {:x=>2018, :y=>776, :press=>1},
    # {:x=>1986, :y=>922, :press=>1},
    # {:x=>1894, :y=>816, :press=>1},
  ]

  locations.each do |location|
    click(location)
    puts location
    sleep_variance
  end
end

def click(location)
  @mouse.click location[:x], location[:y], location[:press]
end

def sleep_variance
  variance = rand(3) / 100.to_f
  fixed = 0.5
  sleep(variance + fixed)
end

eth_cycle
