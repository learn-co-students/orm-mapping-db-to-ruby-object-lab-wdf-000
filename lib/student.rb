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


  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * from students
      where name = ?
    SQL
    new_from_db(DB[:conn].execute(sql, name)[0])
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT COUNT(*) FROM students
      WHERE grade = ?
    SQL

    DB[:conn].execute(sql, 9)
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT COUNT(*) FROM students
      WHERE grade < ?
    SQL

    DB[:conn].execute(sql, 12)
  end

  def self.all
    sql = <<-SQL
      SELECT * FROM students
    SQL

    DB[:conn].execute(sql).map do |row|
      new_from_db(row)
    end

  end

  def self.first_x_students_in_grade_10(num_students)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = ?
      LIMIT ?
    SQL
    DB[:conn].execute(sql, 10, num_students).map do |row|
      new_from_db(row)
    end
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

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = ?
      LIMIT ?
    SQL
    new_from_db(DB[:conn].execute(sql, 10, 1)[0])
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      select * FROM students
      where grade = ?
    SQL

    DB[:conn].execute(sql,grade).map do |row|
      new_from_db(row)
    end

  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
