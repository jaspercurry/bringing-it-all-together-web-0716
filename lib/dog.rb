class Dog
  attr_accessor :name, :breed, :id

  def initialize(id: nil, name:, breed:)
    @name = name
    @breed = breed
    @id = id
  end

  def self.create_table
    sql = "CREATE TABLE IF NOT EXISTS dogs (
    id INTEGER PRIMARY KEY,
    name TEXT,
    breed TEXT)"
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE dogs"
    DB[:conn].execute(sql)
  end

  def save
    sql = "INSERT INTO dogs (name, breed)
    VALUES (?, ?)"
    DB[:conn].execute(sql, self.name, self.breed)

    sql = "SELECT id FROM dogs ORDER BY id DESC LIMIT 1"
    id_array = DB[:conn].execute(sql)

    self.id=id_array[0][0]

    self
  end

  def update
    sql = "UPDATE dogs SET name = ?, breed = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.breed, self.id)
  end

  def self.create(name:, breed:)
    new_dog = Dog.new(name: name, breed: breed)
    new_dog.save
  end

  def self.find_by_id(id)
    sql = "SELECT * FROM dogs WHERE id = ?"
    row = DB[:conn].execute(sql, id)

    self.new_from_db(row[0])

  end

  def self.new_from_db(row)
    new_dog = Dog.new(id: row[0], name: row[1], breed: row[2])
  end

  def self.find_or_create_by(name:, breed:)

    sql = "SELECT * FROM dogs WHERE name = ? AND breed = ?"
    dog_array = DB[:conn].execute(sql, name, breed)
    if dog_array.empty?
      dog = self.create(name: name, breed: breed)
    else
      self.new_from_db(dog_array[0])
    end
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM dogs WHERE name = ?"
    row = DB[:conn].execute(sql, name)
    self.new_from_db(row[0])
  end


end