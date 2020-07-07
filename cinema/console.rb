require('pry-byebug')
require_relative('models/customer')
require_relative('models/film')
require_relative('models/ticket')
require_relative('models/screening')

Ticket.delete_all
Screening.delete_all
Customer.delete_all
Film.delete_all

customer1 = Customer.new({'name' => 'Tim', 'funds' => '100'})
customer2 = Customer.new({'name' => 'Lisa', 'funds' => '120'})
customer3 = Customer.new({'name' => 'Sally', 'funds' => '150'})
customer4 = Customer.new({'name' => 'Rachel', 'funds' => '130'})
customer1.save()
customer2.save()
customer3.save()
customer4.save()

screening1 = Screening.new({'time' => '18:00'})
screening2 = Screening.new({'time' => '20:00'})
screening3 = Screening.new({'time' => '21:00'})
screening1.save()
screening2.save()
screening3.save()

film1 = Film.new({'title' => 'Jaws', 'price' => '5'})
film2 = Film.new({'title' => 'Jurassic Park', 'price' => '10'})
film3 = Film.new({'title' => 'Titanic', 'price' => '15'})
film4 = Film.new({'title' => 'Indiana Jones', 'price' => '5'})
film1.save()
film2.save()
film3.save()
film4.save()

ticket1 = Ticket.new({'customer_id' => customer1.id, 'film_id' => film1.id, 'screening_id' => screening1.id})
ticket2 = Ticket.new({'customer_id' => customer2.id, 'film_id' => film1.id, 'screening_id' => screening2.id})
ticket3 = Ticket.new({'customer_id' => customer3.id, 'film_id' => film3.id, 'screening_id' => screening2.id})
ticket4 = Ticket.new({'customer_id' => customer1.id, 'film_id' => film2.id, 'screening_id' => screening2.id})
ticket5 = Ticket.new({'customer_id' => customer2.id, 'film_id' => film1.id, 'screening_id' => screening2.id})
ticket1.save()
ticket2.save()
ticket3.save()
ticket4.save()
ticket5.save()


ticket3.delete()
customer3.delete()
film3.delete()
screening3.delete()

film1.price = '15'
film1.update()

customer2.name = 'Laura'
customer2.update()

ticket2.film_id = film2.id
ticket2.update()

screening1.time = '17:30'
screening1.update()

Ticket.customer_buys_ticket(customer4, film1, screening1)

binding.pry
nil