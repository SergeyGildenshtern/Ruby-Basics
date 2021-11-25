require_relative 'passenger_train'
require_relative 'passenger_van'
require_relative 'cargo_train'
require_relative 'cargo_van'
require_relative 'station'
require_relative 'route'

class Program
  def initialize
    @trains = []
    @routes = []
  end

  def start
    while true
      puts "\n1) Операции над поездами"
      puts "2) Операции над маршрутами"
      puts "3) Операции над станциями"
      puts "4) Завершить работу"

      print "Выберите действие:"
      case gets.chomp
      when "1"
        train_operations
      when "2"
        route_operations
      when "3"
        station_operations
      when "4"
        break
      else
        puts "Вводите номер команды!"
      end
    end
  end


  private

  def train_operations
    puts "\n1) Создать поезд"
    puts "2) Дополнительные операции"
    puts "3) Назад"

    print "Выберите действие:"
    case gets.chomp
    when "1"
      create_train
    when "2"
      trains_operations_additional
    when "3"
    else
      puts "Вводите номер команды!"
    end
  end

  def create_train
    print "Введите номер поезда:"
    train_number = gets.chomp
    print "Введите тип поезда:"
    train_type = gets.chomp
    if train_type == "пассажирский"
      @trains << PassengerTrain.new(train_number)
    elsif train_type == "грузовой"
      @trains << CargoTrain.new(train_number)
    else
      puts "Недопустимый тип поезда!"
    end
  rescue RuntimeError => e
    puts e.message
    retry
  else
    puts "Создан #{train_type} поезд №#{train_number}"
  end

  def trains_operations_additional
    print "Введите номер поезда:"
    train_number = gets.chomp
    train = @trains.find { |train| train.number == train_number}
    if train
      puts "\n1) Назначить маршрут"
      puts "2) Прицепить вагон"
      puts "3) Отцепить вагон"
      puts "4) Переместить поезд на следующую станцию"
      puts "5) Переместить поезд на предыдущую станцию"
      puts "6) Список вагонов у поезда"
      puts "7) Занять место / объем в вагоне"
      puts "8) Назад"

      print "Выберите действие:"
      case gets.chomp
      when "1"
        set_route(train, train_number)
      when "2"
        attach_van(train, train_number)
      when "3"
        detach_van(train, train_number)
      when "4"
        move_train_to_next_station(train, train_number)
      when "5"
        move_train_to_previous_station(train, train_number)
      when "6"
        show_train_vans(train, train_number)
      when "7"
        take_seat_or_volume(train, train_number)
      when "8"
      else
        puts "Вводите номер команды!"
      end
    else
      puts "Поезд №#{train_number} не найден!"
    end
  end

  def set_route(train, train_number)
    print "Введите номер маршрута:"
    route_id = gets.chomp.to_i
    route = @routes[route_id - 1]
    if route
      train.route = route
      puts "Поезду №#{train_number} присвоен маршрут №#{route_id}"
    else
      puts "Маршрут №#{route_id} не найден!"
    end
  end

  def attach_van(train, train_number)
    if train.type == "пассажирский"
      print "Введите общее количество мест вагона:"
      van = PassengerVan.new(gets.chomp.to_i)
    else
      print "Введите общий объём вагона:"
      van = CargoVan.new(gets.chomp.to_i)
    end

    if train.attach_van(van)
      puts "К поезду №#{train_number} присоединён #{van.type} вагон"
    else
      puts "Нельзя присоединить вагон к движущемуся поезду!!"
    end

  rescue RuntimeError => e
    puts e.message
    retry
  end

  def detach_van(train, train_number)
    if train.vans.any?
      van = train.vans.last
      if train.detach_van(van)
        puts "#{van.type.capitalize} вагон отсоединён от поезда №#{train_number}"
      else
        puts "Нельзя отсоединить вагон от движущемуся поезда!"
      end
    else
      puts "У поезда №#{train_number} не вагонов!"
    end
  end

  def move_train_to_next_station(train, train_number)
    if train.route
      if train.go_next_station
        puts "Поезд №#{train_number} перемещён на следующую станцию"
      else
        puts "Поезд №#{train_number} находится на конечной станции!"
      end
    else
      puts "Поезду №#{train_number} не присвоен маршрут!"
    end
  end

  def move_train_to_previous_station(train, train_number)
    if train.route
      if train.go_previous_station
        puts "Поезд №#{train_number} перемещён на предыдущую станцию"
      else
        puts "Поезд №#{train_number} находится на начальной станции!"
      end
    else
      puts "Поезду №#{train_number} не присвоен маршрут!"
    end
  end

  def show_train_vans(train, train_number)
    if train.vans.size.zero?
      puts "У поезда №#{train_number} нет вагонов!"
    else
      puts "Вагоны поезда №#{train_number}:"
      index = 0
      if train.type == "пассажирский"
        train.train_vans { |van| puts "--- Пассажирский вагон №#{index += 1}, кол-во свободных мест: #{van.available_seats_quantity}, кол-во занятых мест: #{van.occupied_seats_quantity}" }
      else
        train.train_vans { |van| puts "--- Грузовой вагон №#{index += 1}, кол-во свободного объёма: #{van.available_volume}, кол-во занятого объёма: #{van.occupied_volume}" }
      end
    end
  end

  def take_seat_or_volume(train, train_number)
    if train.vans.size.zero?
      puts "У поезда №#{train_number} нет вагонов!"
    else
      print "Введите номер вагона:"
      van_number = gets.chomp.to_i
      if van_number > 0 && van_number <= train.vans.size
        if train.type == "пассажирский"
          if (train.vans[van_number - 1].take_seat).nil?
            puts "В вагоне №#{train_number} нет свободных мест!"
          else
            puts "В вагоне №#{train_number} занято одно место"
          end
        else
          print "Введите занимаемый объём в вагоне №#{train_number}:"
          volume = gets.chomp.to_i
          if (train.vans[van_number - 1].take_volume volume).nil?
            puts "В вагоне №#{train_number} нет свободного объёма!"
          else
            puts "В вагоне №#{train_number} занято #{volume} объёма"
          end
        end
      else
        puts "Вагон №#{train_number} не найден!"
      end
    end
  end



  def route_operations
    puts "\n1) Создать маршрут"
    puts "2) Добавть / Удалить станцию"
    puts "3) Назад"

    print "Выберите действие:"
    case gets.chomp
    when "1"
      create_route
    when "2"
      route_operations_additional
    when "3"
    else
      puts "Вводите номер команды!"
    end
  end

  def create_route
    print "Введите название начальной станции:"
    start_station = Station.new(gets.chomp)
    print "Введите название конечной станции:"
    end_station = Station.new(gets.chomp)
    @routes << Route.new(start_station, end_station)
  rescue RuntimeError => e
    puts e.message
    retry
  else
    puts "Создан маршрут №#{@routes.size}: #{@routes.last.show_stations.first.name} --> #{@routes.last.show_stations.last.name}"
  end

  def route_operations_additional
    print "Введите номер маршрута:"
    route_id = gets.chomp.to_i
    route = @routes[route_id - 1]
    if route
      puts "\n1) Добавить промежуточную станцию в маршрут"
      puts "2) Удалить промежуточную станцию из маршрута"
      puts "3) Назад"

      print "Выберите действие:"
      case gets.chomp
      when "1"
        add_midterm_station(route)
      when "2"
        remove_midterm_station(route)
      when "3"
      else
        puts "Вводите номер команды!"
      end
    else
      puts "Маршрут №#{route_id} не найден!"
    end
  end

  def add_midterm_station(route)
    print "Введите название промежуточной станции:"
    route.add_midterm_station(Station.new(gets.chomp))
  rescue RuntimeError => e
    puts e.message
    retry
  else
    puts "Промежуточная станция добавлена"
  end

  def remove_midterm_station(route)
    print "Введите название промежуточной станции:"
    station_name = gets.chomp
    station = route.show_stations.find { |station| station.name == station_name }
    if station
      if station.trains.any?
        puts "Невозможно удалить станцию '#{station_name}', так как на ней находятся поезд(а)!"
      else
        route.remove_midterm_station(station)
        puts "Промежуточная станция '#{station_name}' удалена"
      end
    else
      puts "Промежуточная станция '#{station_name}' не найдена"
    end
  end



  def station_operations
    print "Введите номер маршрута:"
    route_id = gets.chomp.to_i
    route = @routes[route_id - 1]
    if route
      puts "\n1) Вывести список станций"
      puts "2) Вывести список поездов на станции"
      puts "3) Назад"

      print "Выберите действие:"
      case gets.chomp
      when "1"
        show_stations_on_route(route)
      when "2"
        show_trains_on_station(route)
      when "3"
      else
        puts "Вводите номер команды!"
      end
    else
      puts "Маршрут №#{route_id} не найден!"
    end
  end

  def show_stations_on_route(route)
    route.show_stations.each_with_index { |station, index| puts "Станция №#{index + 1}: #{station.name}" }
  end

  def show_trains_on_station(route)
    print "Введите название станции:"
    station_name = gets.chomp
    station = route.show_stations.find { |station| station.name == station_name }
    if station
      if station.trains.any?
        puts "Поезда на станции '#{station_name}':"
        station.station_trains { |tr| puts "--- #{tr.type.capitalize} поезд №#{tr.number} с кол-вом вагонов: #{tr.vans.size}"}
      else
        puts "На станции '#{station_name}' нет поездов"
      end
    else
      puts "Станция '#{station_name}' не найдена!"
    end
  end

end