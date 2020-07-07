require_relative('../db/sql_runner')
require_relative('ticket')

class Customer

    attr_accessor :name, :funds
    attr_reader :id

    def initialize(options)
        @id = options['id'].to_i if options['id']
        @name = options['name']
        @funds = options['funds'].to_i
    end

    def save()
        sql = "INSERT INTO customers
        (name, funds)
        VALUES ($1, $2)
        RETURNING id"
        values = [@name, @funds]
        result = SqlRunner.run(sql, values)
        @id = result[0]['id'].to_i
    end

    def self.delete_all()
        sql = "DELETE FROM customers"
        SqlRunner.run(sql)
    end

    def delete()
        sql = "DELETE FROM customers WHERE id = $1"
        values = [@id]
        SqlRunner.run(sql, values)
    end

    def self.find_all()
        sql = "SELECT * FROM customers"
        result = SqlRunner.run(sql)
        return self.map_items(result)
    end

    def update()
        sql = "UPDATE customers SET
        (name, funds) = ($1, $2)
        WHERE id = $3"
        values = [@name, @funds, @id]
        SqlRunner.run(sql, values)
    end

    def self.map_items(data)
        return data.map { |customer| Customer.new(customer) }
    end

    def films()
        sql = "SELECT films.* FROM films
        INNER JOIN tickets ON
        tickets.film_id = films.id
        WHERE customer_id = $1"
        values = [@id]
        result = SqlRunner.run(sql, values)
        return Film.map_items(result)
    end

    def subtract_price_from_funds()
        sql = "SELECT SUM(films.price) FROM customers
        INNER JOIN tickets ON
        tickets.customer_id = customers.id
        INNER JOIN films ON
        films.id = tickets.film_id
        WHERE customer_id = $1"
        values = [@id]
        price = SqlRunner.run(sql, values).first['sum'].to_i
        @funds -= price
    end

  def number_of_tickets()
        sql = "SELECT * FROM tickets
        WHERE customer_id = $1"
        values = [@id]
        tickets = SqlRunner.run(sql, values)
        result = Ticket.map_items(tickets)
        return result.length
    end


end