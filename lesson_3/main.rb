require_relative 'passenger_train'
require_relative 'passenger_van'
require_relative 'cargo_train'
require_relative 'cargo_van'
require_relative 'station'
require_relative 'route'

trains = []
routes = []

while true
  puts "\n1) Операции над поездами"
  puts "2) Операции над маршрутами"
  puts "3) Операции над станциями"
  puts "4) Завершить работу"

  print "Выберите действие:"
  case gets.chomp
  when "1"
    puts "\n1) Создать поезд"
    puts "2) Дополнительные операции"
    puts "3) Назад"

    print "Выберите действие:"
    case gets.chomp
    when "1"
      puts "Выберите тип поезда:"
      puts "1) Пассажирский"
      puts "2) Грузовой"
      print "Введите число:"
      type = gets.chomp.to_i
      train_id = trains.size + 1
      if type == 1
        train = PassengerTrain.new(train_id)
      elsif type == 2
        train = CargoTrain.new(train_id)
      else
        puts "Недопустимый тип поезда!"
        next
      end

      trains << train
      puts "Создан Поезд №#{train_id}"
    when "2"
      print "Введите номер поезда:"
      train_id = gets.chomp.to_i
      train = trains.find { |train| train.number == train_id}
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
          print "Введите номер маршрута:"
          route_id = gets.chomp.to_i
          route = routes[route_id - 1]
          if route
            train.route = route
            route.show_stations.first.get_train(train)
            puts "Поезду №#{train_id} присвоен маршрут №#{route_id}"
          else
            puts "Маршрут №#{route_id} не найден!"
          end
        when "2"
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
        when "3"
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
        when "4"
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
        when "5"
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
        when "6"
          next
        else
          puts "Вводите номер команды!"
        end
      else
        puts "Поезд №#{train_id} не найден!"
      end
    when "3"
      next
    else
      puts "Вводите номер команды!"
    end
  when "2"
    puts "\n1) Создать маршрут"
    puts "2) Добавть / Удалить станцию"
    puts "3) Назад"

    print "Выберите действие:"
    case gets.chomp
    when "1"
      print "Введите название начальной станции:"
      start_station = Station.new(gets.chomp)
      print "Введите название конечной станции:"
      end_station = Station.new(gets.chomp)
      routes << Route.new(start_station, end_station)
      puts "Создан маршрут №#{routes.size}: #{routes.last.show_stations.first.name} --> #{routes.last.show_stations.last.name}"
    when "2"
      print "Введите номер маршрута:"
      route_id = gets.chomp.to_i
      route = routes[route_id - 1]
      if route
        puts "\n1) Добавить промежуточную станцию в маршрут"
        puts "2) Удалить промежуточную станцию из маршрута"
        puts "3) Назад"

        print "Выберите действие:"
        case gets.chomp
        when "1"
          print "Введите название промежуточной станции:"
          route.add_midterm_station(Station.new(gets.chomp))
          puts "Промежуточная станция добавлена"
        when "2"
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
        when "3"
          next
        else
          puts "Вводите номер команды!"
        end
      else
        puts "Маршрут №#{route_id} не найден!"
      end
    when "3"
      next
    else
      puts "Вводите номер команды!"
    end
  when "3"
    print "Введите номер маршрута:"
    route_id = gets.chomp.to_i
    route = routes[route_id - 1]
    if route
      puts "\n1) Вывести список станций"
      puts "2) Вывести список поездов на станции"
      puts "3) Назад"

      print "Выберите действие:"
      case gets.chomp
      when "1"
          route.show_stations.each_with_index { |station, index| puts "Станция №#{index + 1}: #{station.name}" }
      when "2"
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
      when "3"
        next
      else
        puts "Вводите номер команды!"
      end
    else
      puts "Маршрут №#{route_id} не найден!"
    end
  when "4"
    break
  else
    puts "Вводите номер команды!"
  end
end