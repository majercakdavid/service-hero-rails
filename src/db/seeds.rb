# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
=begin
doc_owner_types=['BusinessOwner', 'Business', 'Administrator', 'Employee', 'Business_Service', 'Business_Service_Order', 'Customer', 'Service']
admin = Administrator.first

#document_owner_types = []
#doc_owner_types.each {
#    |doc_owner_t|
#  document_owner_types.append(DocumentOwnerType.create!(
#      label: doc_owner_t
#  ))
#}

customers =[]
addresses = []
businesses = []
business_owners = []
services = []

100000.times do
  # GENERATE CUSTOMERS AND RELATIONSHIPS

  # Create addresses for the customer
  address_customer1 = Address.create!(
      name: Faker::Name.name_with_middle,
      street: Faker::Address.street_address,
      city: Faker::Address.city,
      ZIP: Faker::Address.zip_code,
      state: Faker::Address.state,
      country: Faker::Address.country,
      phone: Faker::PhoneNumber.cell_phone
  )
  addresses.append(address_customer1)

  address_customer2 = Address.create!(
      name: Faker::Name.name_with_middle,
      street: Faker::Address.street_address,
      city: Faker::Address.city,
      ZIP: Faker::Address.zip_code,
      state: Faker::Address.state,
      country: Faker::Address.country,
      phone: Faker::PhoneNumber.cell_phone
  )
  addresses.append(address_customer2)

  customer_name = Faker::Name.name_with_middle
  customers.append(Customer.create!(
      billing_address_id: address_customer1.id,
      shipping_address_id: address_customer2.id,
      email: Faker::Internet.email(customer_name),
      password_digest: Faker::Internet.password,
      name: customer_name,
      date_joined: Faker::Date.between(10.year.ago, Date.today)
  ))
end

1000.times do
  # GENERATE BUSINESS

  # Create addresses for the business
  address_business1 = Address.create!(
      name: Faker::Name.name_with_middle,
      street: Faker::Address.street_address,
      city: Faker::Address.city,
      ZIP: Faker::Address.zip_code,
      state: Faker::Address.state,
      country: Faker::Address.country,
      phone: Faker::PhoneNumber.cell_phone
  )
  addresses.append(address_business1)

  address_business2 = Address.create!(
      name: Faker::Name.name_with_middle,
      street: Faker::Address.street_address,
      city: Faker::Address.city,
      ZIP: Faker::Address.zip_code,
      state: Faker::Address.state,
      country: Faker::Address.country,
      phone: Faker::PhoneNumber.cell_phone
  )
  addresses.append(address_business2)

  # Create the business
  business = Business.create!(
      billing_address_id: address_business1.id,
      shipping_address_id: address_business2.id,
      administrator_id: admin.id,
      name: Faker::Company.name,
      date_joined: Faker::Date.between(1.year.ago, Date.today)
  )
  businesses.append(business)

  # GENERATE BUSINESS OWNERS AND RELATIONSHIPS

  # Randomly generate the number of the business owners to create
  business_owners_count = 1 + Random.rand(100)
  business_owners_count.times do
    businesses_owner_name = Faker::Name.name_with_middle
    # Create addresses for the business
    address_business_owner1 = Address.create!(
        name: businesses_owner_name,
        street: Faker::Address.street_address,
        city: Faker::Address.city,
        ZIP: Faker::Address.zip_code,
        state: Faker::Address.state,
        country: Faker::Address.country,
        phone: Faker::PhoneNumber.cell_phone
    )
    addresses.append(address_business_owner1)

    address_business_owner2 = Address.create!(
        name: businesses_owner_name,
        street: Faker::Address.street_address,
        city: Faker::Address.city,
        ZIP: Faker::Address.zip_code,
        state: Faker::Address.state,
        country: Faker::Address.country,
        phone: Faker::PhoneNumber.cell_phone
    )
    addresses.append(address_business_owner2)

    business_owner = BusinessOwner.create!(
        billing_address_id: address_business_owner1.id,
        shipping_address_id: address_business_owner2.id,
        email: Faker::Internet.email(businesses_owner_name),
        password_digest: Faker::Internet.password,
        name: businesses_owner_name
    )
    business_owners.append(business_owner)

    BusinessBusinessOwner.create!(
        business_id: business.id,
        business_owner_id: business_owner.id,
        date_from: Faker::Date.between(10.year.ago, 2.years.ago),
        date_to: Faker::Date.between(1.year.ago, Date.today)
    )
  end

  # GENERATE EMPLOYEES AND RELATIONSHIPS
  employees = []
  # Randomly generate the number of the business services to create
  employees_count = 1 + Random.rand(10000)
  employees_count.times do
    employee_name = Faker::Name.name_with_middle
    # Create addresses for the business
    address_employee1 = Address.create!(
        name: employee_name,
        street: Faker::Address.street_address,
        city: Faker::Address.city,
        ZIP: Faker::Address.zip_code,
        state: Faker::Address.state,
        country: Faker::Address.country,
        phone: Faker::PhoneNumber.cell_phone
    )
    addresses.append(address_employee1)

    address_employee2 = Address.create!(
        name: employee_name,
        street: Faker::Address.street_address,
        city: Faker::Address.city,
        ZIP: Faker::Address.zip_code,
        state: Faker::Address.state,
        country: Faker::Address.country,
        phone: Faker::PhoneNumber.cell_phone
    )
    addresses.append(address_employee2)

    employee = Employee.create!(
        business_id: business.id,
        billing_address_id: address_employee1.id,
        shipping_address_id: address_employee2.id,
        email: Faker::Internet.email(employee_name),
        password_digest: Faker::Internet.password,
        name: employee_name
    )
    employees.append(employee)
  end


  # GENERATE BUSINESS SERVICES AND RELATIONSHIPS

  business_services = []
  # Randomly generate the number of the business services to create
  businesses_services_count = 100 + Random.rand(1000)
  businesses_services_count.times do
    service = Service.create!(
        label: Faker::Company.profession,
        description: Faker::Lorem.paragraph,
        date_added: Faker::Date.between(business.date_joined, Date.today)
    )
    services.append(service)

    business_services.append(BusinessService.create!(
        business_id: business.id,
        service_id: service.id,
        price: Faker::Number.decimal(1 + Random.rand(3)),
        date_added: service.date_added
    ))
  end

  # GENERATE ORDERS AND RELATIONSHIPS

  # Randomly generate the number of the orders to create
  order_services = []
  orders_count = 100 + Random.rand(100000)
  orders_count.times do
    order = Order.create!(
        customer_id: customers[Random.rand(customers.length - 1)].id,
        date_created: Faker::Date.between(10.year.ago, 2.years.ago)
    )
    order_services_count = 1 + Random.rand(11)
    order_services_count.times do
      order_service = BusinessServiceOrder.create!(
          business_service_id: business_services[Random.rand(business_services.length - 1)].id,
          order_id: order.id,
          label: Faker::Lorem.word,
          description: Faker::Lorem.paragraph,
          date_created: Faker::Date.between(order.date_created, 2.years.ago)
      )
      order_services.append(order_service)
    end
  end
end

# GENERATE DOCUMENTS AND RELATIONSHIPS

# Randomly generate the number of the documents to create
doc_count = 1000000
business_owners = BusinessOwner.all
businesses = Business.all
admin = Administrator.first
employees = Employee.all
business_services = BusinessService.all
order_services = BusinessServiceOrder.all
customers = Customer.all
services = Service.all
doc_count.times do
  owner_type = doc_owner_types[Random.rand(doc_owner_types.length - 1)]
  owner = nil

  if owner_type == 'BusinessOwner'
    owner = business_owners[Random.rand(business_owners.length - 1)]
  elsif owner_type =='Business' then
    owner = businesses[Random.rand(businesses.length - 1)]
  elsif owner_type == 'Administrator' then
    owner = admin
  elsif owner_type == 'Employee' then
    owner = employees[Random.rand(employees.length - 1)]
  elsif owner_type == 'Business_Service' then
    owner = business_services[Random.rand(business_services.length - 1)]
  elsif owner_type == 'Business_Service_Order' then
    owner = order_services[Random.rand(order_services.length - 1)]
  elsif owner_type == 'Customer' then
    owner = customers[Random.rand(customers.length - 1)]
  elsif owner_type == 'Service' then
    owner = services[Random.rand(services.length - 1)]
  end
  owner.documents.create!(
      label: Faker::Lorem.word,
      data: "",
      dataurl: Faker::Avatar.image,
      description: Faker::Lorem.paragraph
  )
end
=end

connection = ActiveRecord::Base.connection.raw_connection
connection.prepare('create_user', 'INSERT INTO "users" ("id" ,"email", "encrypted_password", "role_id", "role_type", "created_at", "updated_at") VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING "id"')
#Administrator.all.select(:id, :email, :password_digest, :created_at, :updated_at).each {
#    |admin|
#  connection.exec_prepared('create_user', [ admin.email, admin.password_digest, admin.id,
#                                                 'Administrator', admin.created_at, admin.updated_at ])
#}
connection.exec_prepared('create_user', [ 4, "admin@test.com", '$2a$11$Px6tZ8kzukcjoDB3YgWqZ.ym2Sr2taWFVv.Xl0NWbq5bTcZLfgLcm', 2,
                                          'Administrator', Time.now, Time.now ])
connection.exec_prepared('create_user', [ 5, "davidmajercak@hotmail.com", '$2a$11$Px6tZ8kzukcjoDB3YgWqZ.ym2Sr2taWFVv.Xl0NWbq5bTcZLfgLcm', 3,
                                               'Administrator', Time.now, Time.now ])
=begin
BusinessOwner.all.select(:id, :email, :password_digest, :created_at, :updated_at).each {
    |business_owner|
  connection.exec_prepared('create_user', [ business_owner.email, business_owner.password_digest, business_owner.id,
                                            'BusinessOwner', business_owner.created_at, business_owner.updated_at ])
}
Employee.all.select(:id, :email, :password_digest, :created_at, :updated_at).each {
    |employee|
  connection.exec_prepared('create_user', [ employee.email, employee.password_digest, employee.id,
                                            'Employee', employee.created_at, employee.updated_at ])
}
Customer.all.select(:id, :email, :password_digest, :created_at, :updated_at).each {
    |customer|
  connection.exec_prepared('create_user', [ customer.email, customer.password_digest, customer.id,
                                            'Customer', customer.created_at, customer.updated_at ])
}
=end