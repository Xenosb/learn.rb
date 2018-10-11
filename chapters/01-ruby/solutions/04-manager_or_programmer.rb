class Employee
  attr_accessor :full_name
  attr_accessor :id

  def initialize(full_name, id)
    @full_name = full_name
    @id = id
  end

  def surname
    @full_name.split(' ', 2).last
  end

  def first_name
    @full_name.split(' ', 2).first
  end
end

class Programmer < Employee
  attr_accessor :languages

  def initialize(full_name, id, languages)
    super(full_name, id)
    @languages = languages
  end
end

class OfficeManager < Employee
  attr_accessor :office

  def initialize(full_name, id, office)
    super(full_name, id)
    @office = office
  end
end

def add_employee(employees)
  puts '[Add an employee]'
  print 'Full name: '
  full_name = gets.chomp
  print 'ID: '
  id = gets.chomp

  print 'Is the person an [e]mployee, [p]rogrammer or an [o]ffice manager? '
  employee =
    case get_action
    when 'p'
      print 'Programming languages: '
      Programmer.new(full_name, id, gets.chomp.split(','))
    when 'o'
      print 'Office: '
      OfficeManager.new(full_name, id, gets.chomp)
    else
      Employee.new(full_name, id)
    end

  employees << employee
end

def edit_employee(employees)
  puts '[Edit an employee]'
  print 'ID of the employee you want to edit: '
  id = gets.chomp
  employee = employees.find { |e| e.id == id }

  unless employee
    puts 'No such employee!'
    return
  end

  puts "Current full name: #{employee.full_name}"
  print 'New full name: '
  employee.full_name = gets.chomp
  puts "Current id: #{employee.id}"
  print 'New ID: '
  employee.id = gets.chomp

  case employee
  when Programmer
    print "Languages: "
    employee.languages = gets.chomp.split(',')
  when OfficeManager
    print "Office: "
    employee.office = gets.chomp
  end
end

def view_employees(employees)
  sorted_employees(employees).each do |employee|
    print "#{employee.full_name}, #{employee.id}"
    case employee
    when Programmer then print " #{employee.languages.inspect}"
    when OfficeManager then print " (#{employee.office})"
    end
    print "\n"
  end
end

def sorted_employees(employees)
  print 'Sort by [f]irst name or [l]ast name? '
  key = get_action

  employees.sort_by do |employee|
    if key == 'f'
      employee.first_name
    else
      employee.surname
    end
  end
end

def quit
  puts 'Goodbye!'
  exit
end

def print_help
  puts '[HELP]'
  puts 'Enter one of the following:'
  puts 'a - to add a new employee'
  puts 'e - to edit an existing employee'
  puts 'v - to view existing employees'
  puts 'q - to quit the program'
end

def get_action
  gets.downcase[0]
end

puts 'Employee-o-matic 4000'

employees = []

loop do
  print 'What do you want to do? '
  action = get_action

  case action
  when 'a' then add_employee(employees)
  when 'e' then edit_employee(employees)
  when 'v' then view_employees(employees)
  when 'q' then quit
  else
    print_help
  end
end
