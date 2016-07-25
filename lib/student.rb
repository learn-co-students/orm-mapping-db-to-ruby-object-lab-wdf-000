class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = self.new
    student.id, student.name, student.grade = row[0], row[1], row[2]
    student
  end

  def self.all
    sql = "SELECT * FROM students"

    student = DB[:conn].execute(sql)
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name=? LIMIT 1"

    student = DB[:conn].execute(sql,name).flatten
    self.new_from_db(student)
  end

  def self.count_all_students_in_grade_9
    sql = "SELECT COUNT(*) FROM students WHERE grade=9;"
    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = "SELECT * FROM students WHERE grade<12;"
    DB[:conn].execute(sql)
  end

  def self.first_x_students_in_grade_10(num)
    sql = "SELECT * FROM students WHERE grade=10 ORDER BY students.id LIMIT ?;"
    DB[:conn].execute(sql, num)
  end

  def self.first_student_in_grade_10
    student = self.first_x_students_in_grade_10(1).flatten
    self.new_from_db(student)
  end

  def self.all_students_in_grade_X(num)
    sql = "SELECT * FROM students WHERE grade=?;"
    DB[:conn].execute(sql, num)
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
