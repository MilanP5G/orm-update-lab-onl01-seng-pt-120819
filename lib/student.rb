require_relative "../config/environment.rb"

class Student
  attr_accessor :name, :grade
  attr_reader :id 
  
  def initialize(name, grade, id=nil)
    @id = id 
    @name = name 
    @grade = grade
  end 
  
  def self.create_table 
    sql = <<-SQL 
     CREATE TABLE IF NOT EXISTS students (
     id INTEGER PRIMARY KEY,
     name TEXT,
     grade INTEGER
     )
    SQL
     
     DB[:conn].execute(sql)
   end 
   
   def self.drop_table
     sql = <<-SQL
       DROP TABLE IF EXISTS students 
     SQL
     
     DB[:conn].execute(sql)
     
   end 
   
   def save 
     if self.id 
       self.update 
     else 
       sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?, ?)
       SQL
       DB[:conn].execute(sql, self.name, self.grade)
       @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
     end 
   end
   
   def self.create(name, grade)
     new_student = Student.new(name, grade)
     new_student.save
     new_student
   end
   
   def self.new_from_db(row)
     
     
   end 
   
   def update
     sql = "UPDATE students SET name = ?, grade = ? WHERE name = ?"
     DB[:conn].execute(sql, self.name, self.grade, self.name)
   end


end
