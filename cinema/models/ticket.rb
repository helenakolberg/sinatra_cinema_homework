require_relative('../db/sql_runner')

class Ticket

    attr_accessor :customer_id, :film_id
    attr_reader :id

    def initialize(options)
        @id = options['id'].to_i if options['id']
        @customer_id = options['customer_id'].to_i
        @film_id = options['film_id'].to_i
        @screening_id = options['screening_id']
    end

    def save()
        sql = "INSERT INTO tickets
        (customer_id, film_id, screening_id)
        VALUES ($1, $2, $3)
        RETURNING id"
        values = [@customer_id, @film_id, @screening_id]
        result = SqlRunner.run(sql, values)
        @id = result[0]['id'].to_i
    end

    def self.delete_all()
        sql = "DELETE FROM tickets"
        SqlRunner.run(sql)
    end

    def delete()
        sql = "DELETE FROM tickets WHERE id = $1"
        values = [@id]
        SqlRunner.run(sql, values)
    end

    def self.find_all()
        sql = "SELECT * FROM tickets"
        result = SqlRunner.run(sql)
        return self.map_items(result)
    end

    def update()
        sql = "UPDATE tickets SET
        (customer_id, film_id, screening_id) = ($1, $2, $3)
        WHERE id = $4"
        values = [@customer_id, @film_id, @screening_id, @id]
        SqlRunner.run(sql, values)
    end

    def self.map_items(data)
        return data.map { |ticket| Ticket.new(ticket) }
    end

    def self.customer_buys_ticket(customer, film, screening)
        sql = "INSERT INTO tickets
        (customer_id, film_id, screening_id)
        VALUES ($1, $2, $3)
        RETURNING id"
        values = [customer.id, film.id, screening.id]
        result = SqlRunner.run(sql, values)
        @id = result[0]['id'].to_i
        customer.subtract_price_from_funds
    end

end