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
    puts "Выберите тип поезда:"
    puts "1) Пассажирский"
    puts "2) Грузовой"
    print "Введите число:"
    type = gets.chomp.to_i
    train_id = @trains.size + 1
    if (1..2).include? type
      if type == 1
        train = PassengerTrain.new(train_id)
      else
        train = CargoTrain.new(train_id)
      end
      @trains << train
      puts "Создан #{train.type} поезд №#{train_id}"
    else
      puts "Недопустимый тип поезда!"
    end
  end

  def trains_operations_additional
    print "Введите номер поезда:"
    train_id = gets.chomp.to_i
    train = @trains.find { |train| train.number == train_id}
    if train
      puts "\n1) Назначить маршрут"
      puts "2) Прицепить вагон"
      puts "3) Отцепить вагон"
      puts "4) Переместить поезд на следующую станцию"
      puts "5) Переместить поезд на предыдущую станцию"
      puts "6) Назад"

      print "Выберите действие:"
      case gets.chomp
      when "1"
        set_route(train, train_id)
      when "2"
        attach_van(train, train_id)
      when "3"
        detach_van(train, train_id)
      when "4"
        move_train_to_next_station(train, train_id)
      when "5"
        move_train_to_previous_station(train, train_id)
      when "6"
      else
        puts "Вводите номер команды!"
      end
    else
      puts "Поезд №#{train_id} не найден!"
    end
  end

  def set_route(train, train_id)
    print "Введите номер маршрута:"
    route_id = gets.chomp.to_i
    route = @routes[route_id - 1]
    if route
      train.route = route
      route.show_stations.first.get_train(train)
      puts "Поезду №#{train_id} присвоен маршрут №#{route_id}"
    else
      puts "Маршрут №#{route_id} не найден!"
    end
  end

  def attach_van(train, train_id)
    if train.type == "пассажирский"
      van = PassengerVan.new
    else
      van = CargoVan.new
    end

    if train.attach_van(van)
      puts "К поезду №#{train_id} присоединён #{van.type} вагон"
    else
      puts "Нельзя присоединить вагон к движущемуся поезду!!"
    end
  end

  def detach_van(train, train_id)
    if train.vans.any?
      van = train.vans.last
      if train.detach_van(van)
        puts "#{van.type.capitalize} вагон отсоединён от поезда №#{train_id}"
      else
        puts "Нельзя отсоединить вагон от движущемуся поезда!"
      end
    else
      puts "У поезда №#{train_id} не вагонов!"
    end
  end

  def move_train_to_next_station(train, train_id)
    if train.route
      if train.next_station
        train.go_next_station
        train.previous_station.send_train(train)
        train.station.get_train(train)
        puts "Поезд №#{train_id} перемещён на следующую станцию"
      else
        puts "Поезд №#{train_id} находится на конечной станции!"
      end
    else
      puts "Поезду №#{train_id} не присвоен маршрут!"
    end
  end

  def move_train_to_previous_station(train, train_id)
    if train.route
      if train.previous_station
        train.go_previous_station
        train.next_station.send_train(train)
        train.station.get_train(train)
        puts "Поезд №#{train_id} перемещён на предыдущую станцию"
      else
        puts "Поезд №#{train_id} находится на начальной станции!"
      end
    else
      puts "Поезду №#{train_id} не присвоен маршрут!"
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
        station.trains_by("пассажирский").each { |train| puts "--- Пассажирский поезд №#{train.number}" }
        station.trains_by("грузовой").each { |train| puts "--- Грузовой поезд №#{train.number}" }
      else
        puts "На станции '#{station_name}' нет поездов"
      end
    else
      puts "Станция '#{station_name}' не найдена!"
    end
  end

end