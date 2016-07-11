require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = Student.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    all_students = []
    all_rows = DB[:conn].execute("SELECT * FROM students")
    all_rows.each{|row| all_students << new_from_db(row)}
    all_students
  end

  def self.find_by_name(name)
    row = DB[:conn].execute("SELECT id, grade FROM students where name = ?", name)
    new_student = Student.new
    new_student.name = name
    new_student.id = row[0]
    new_student.grade = row[1]
    new_student
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

  def self.count_all_students_in_grade_9
    all.select{|student| student.grade == "9"}
  end

  def self.students_below_12th_grade
    all.select{|student| student.grade.to_i < 12}
  end

  def self.first_x_students_in_grade_10(num)
    all.select{|student| student.id <= num && student.grade == "10"}
  end

  def self.first_student_in_grade_10
    all.detect{|student| student.grade == "10"}
  end

  def self.all_students_in_grade_X(num)
    all.select{|student| student.grade.to_i == num}
  end


end
