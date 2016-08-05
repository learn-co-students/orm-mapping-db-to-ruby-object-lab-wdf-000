require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = Student.new.tap do |student|
      student.id = row[0]
      student.name = row[1]
      student.grade = row[2]
    end
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class

    sql = <<-SQL
      SELECT * FROM students
    SQL

    DB[:conn].execute(sql).map { |row| self.new_from_db(row) }
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    self.all.detect {|student| student.name == name }
  end

  def self.count_all_students_in_grade_9
    self.all.select { |student| student.grade == "9" }
  end

  def self.students_below_12th_grade
    self.all.select { |student| student.grade  < "12" }
  end

  def self.first_x_students_in_grade_10(num)
    self.all.select { |student| student.grade == "10" }[0...num]
  end

  def self.first_student_in_grade_10
    self.all.detect { |student| student.grade == "10" }
  end

  def self.all_students_in_grade_X(grade)
    self.all.select { |student| student.grade == grade.to_s }
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
