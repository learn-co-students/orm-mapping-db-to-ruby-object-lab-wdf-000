require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 9
    SQL

    DB[:conn].execute(sql).collect{|row| self.new_from_db(row)}
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade < 12
    SQL

    DB[:conn].execute(sql).collect{|row| self.new_from_db(row)}
  end

  def self.all
    sql = <<-SQL
      SELECT *
      FROM students
    SQL
    # binding.pry
    DB[:conn].execute(sql).collect{|row| self.new_from_db(row)}
  end


  def self.new_from_db(row)
    # create a new Student object given a row from the database
    # binding.pry
    self.new.tap do |student|
      student.id = row[0]
      student.name = row[1]
      student.grade = row[2]
    end
  end

  def self.first_x_students_in_grade_10(number_students)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
      LIMIT ?
    SQL
    # binding.pry
    DB[:conn].execute(sql,number_students).collect{|row| self.new_from_db(row)}
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
    SQL
    # binding.pry
    DB[:conn].execute(sql).collect{|row| self.new_from_db(row)}.first
  end

  def self.all_students_in_grade_X(students_grade)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = ?
    SQL
    # binding.pry
    DB[:conn].execute(sql,students_grade).collect{|row| self.new_from_db(row)}
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class

    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
    SQL

    DB[:conn].execute(sql,name).collect{|row| self.new_from_db(row)}.first
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
