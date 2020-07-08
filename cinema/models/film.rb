require_relative('../db/sql_runner')

class Film

    attr_accessor :title, :price
    attr_reader :id

    def initialize(options)
        @id = options['id'].to_i if options['id']
        @title = options['title']
        @price = options['price'].to_i
    end

    def save()
        sql = "INSERT INTO films
        (title, price)
        VALUES ($1, $2)
        RETURNING id"
        values = [@title, @price]
        result = SqlRunner.run(sql, values)
        @id = result[0]['id'].to_i
    end

    def self.delete_all()
        sql = "DELETE FROM films"
        SqlRunner.run(sql)
    end

    def delete()
        sql = "DELETE FROM films WHERE id = $1"
        values = [@id]
        SqlRunner.run(sql, values)
    end

    def self.find_all()
        sql = "SELECT * FROM films"
        result = SqlRunner.run(sql)
        return self.map_items(result)
    end

    def update()
        sql = "UPDATE films SET
        (title, price) = ($1, $2)
        WHERE id = $3"
        values = [@title, @price, @id]
        SqlRunner.run(sql, values)
    end

    def self.map_items(data)
        return data.map { |film| Film.new(film) }
    end

    def customers()
        sql = "SELECT customers.* FROM customers
        INNER JOIN tickets on
        tickets.customer_id = customers.id
        WHERE film_id = $1"
        values = [@id]
        result = SqlRunner.run(sql, values)
        return Customer.map_items(result)
    end

    def how_many_customers()
        sql = "SELECT customers.* FROM customers
        INNER JOIN tickets on
        tickets.customer_id = customers.id
        WHERE film_id = $1"
        values = [@id]
        customers = SqlRunner.run(sql, values)
        result = Customer.map_items(customers)
        return result.length
    end

    def screenings()
        sql = "SELECT screenings.* FROM screenings
        INNER JOIN tickets ON
        tickets.screening_id = screenings.id
        WHERE tickets.film_id = $1"
        values = [@id]
        result = SqlRunner.run(sql, values)
        return Screening.map_items(result)
    end

    def self.find_by_id(id)
        sql = "SELECT * FROM films
        WHERE id = $1"
        values = [@id]
        result = SqlRunner.run(sql, values)
        return self.map_items(result)
    end

end