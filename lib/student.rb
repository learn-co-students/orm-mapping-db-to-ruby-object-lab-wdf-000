class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
	  tmp = Student.new
	  tmp.id = row[0]
	  tmp.name = row[1]
	  tmp.grade = row[2]
	  tmp
  end

  def self.all
		DB[:conn].execute("SELECT * FROM students").map do |x|
			Student.new_from_db(x)
		end
  end

	def self.count_all_students_in_grade_9
		arr = DB[:conn].execute("SELECT * FROM students WHERE grade == 9")
		arr.map do |x|
			Student.new_from_db(x)
		end
	end

	def self.all_students_in_grade_X(grade)
		arr = DB[:conn].execute("SELECT * FROM students WHERE grade == ?",grade)
		arr.map do |x|
			Student.new_from_db(x)
		end
	end

	def self.first_x_students_in_grade_10(count)
		DB[:conn].execute("SELECT * FROM students WHERE grade == 10 LIMIT ?;",count).map do |x|
			Student.new_from_db(x)
		end
	end

  def self.first_student_in_grade_10
	  row = DB[:conn].execute("SELECT * FROM students WHERE grade == 10 LIMIT 1;")[0]
	  Student.new_from_db(row)
  end

	def self.students_below_12th_grade
		DB[:conn].execute("SELECT * FROM students WHERE grade < 12").map do |x|
			Student.new_from_db(x)
		end
	end

  def self.find_by_name(name)
	  row = DB[:conn].execute("SELECT * FROM students WHERE name == ?;",name)[0]
	  Student.new_from_db(row)
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
