# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
=begin
connection = ActiveRecord::Base.connection.raw_connection
connection.prepare('create_user', 'INSERT INTO "users" ("email", "encrypted_password", "role_id", "role_type", "created_at", "updated_at") VALUES ($1, $2, $3, $4, $5, $6) RETURNING "id"')
connection.prepare('create_administrator', 'INSERT INTO "administrators" ("name", "created_at", "updated_at") VALUES ($1, $2, $3) RETURNING "id"')
connection.prepare('create_businessowner', 'INSERT INTO "business_owners" ("name", "billing_address_id", "shipping_address_id", "created_at", "updated_at") VALUES ($1, $2, $3, $4, $5) RETURNING "id"')
connection.prepare('create_customer', 'INSERT INTO "customers" ("name", "billing_address_id", "shipping_address_id", "created_at", "updated_at") VALUES ($1, $2, $3, $4, $5) RETURNING "id"')
connection.prepare('create_employee', 'INSERT INTO "employees" ("name", "business_id", "billing_address_id", "shipping_address_id", "created_at", "updated_at") VALUES ($1, $2, $3, $4, $5, $6) RETURNING "id"')
connection.prepare('create_address', 'INSERT INTO "addresses" ("name", "street", "city", "ZIP", "state", "country", "phone", "created_at", "updated_at") VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING "id"')
connection.prepare('create_business_businessowner', 'INSERT INTO "business_business_owners" ("business_id", "business_owner_id", "date_from", "created_at", "updated_at") VALUES ($1, $2, $3, $4, $5) RETURNING "id"')
connection.prepare('create_business_service_order', 'INSERT INTO "business_service_orders" ("business_service_id", "order_id", "label", "description", "date_created", "created_at", "updated_at") VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING "id"')
connection.prepare('create_business_service', 'INSERT INTO "business_services" ("business_id", "service_id", "price", "date_added", "created_at", "updated_at") VALUES ($1, $2, $3, $4, $5, $6) RETURNING "id"')
connection.prepare('create_business', 'INSERT INTO "businesses" ("billing_address_id", "shipping_address_id", "name", "date_joined", "created_at", "updated_at") VALUES ($1, $2, $3, $4, $5, $6) RETURNING "id"')
connection.prepare('create_document', 'INSERT INTO "documents" ("documentable_type", "documentable_id", "label", "data", "dataurl", "description", "created_at", "updated_at") VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING "id"')
connection.prepare('create_order', 'INSERT INTO "orders" ("customer_id", "date_created", "created_at", "updated_at") VALUES ($1, $2, $3, $4) RETURNING "id"')
connection.prepare('create_service', 'INSERT INTO "services" ("label", "description", "date_added", "created_at", "updated_at") VALUES ($1, $2, $3, $4, $5) RETURNING "id"')

doc_owner_types=['BusinessOwner', 'Business', 'Administrator', 'Employee', 'Business_Service', 'Business_Service_Order', 'Customer', 'Service']

customers =[]
addresses = []
businesses = []
business_owners = []
services = []
users = []

100000.times do
  # GENERATE CUSTOMERS AND RELATIONSHIPS

  # Create addresses for the customer
  address_customer1 = connection.exec_prepared('create_address', [
      Faker::Name.name_with_middle,
      Faker::Address.street_address,
      Faker::Address.city,
      Faker::Address.zip_code,
      Faker::Address.state,
      Faker::Address.country,
      Faker::PhoneNumber.cell_phone,
      Time.now,
      Time.now
  ])[0]['id']

  addresses.append(address_customer1)

  address_customer2 = connection.exec_prepared('create_address', [
      Faker::Name.name_with_middle,
      Faker::Address.street_address,
      Faker::Address.city,
      Faker::Address.zip_code,
      Faker::Address.state,
      Faker::Address.country,
      Faker::PhoneNumber.cell_phone,
      Time.now,
      Time.now
  ])[0]['id']
  addresses.append(address_customer2)

  customer_name = Faker::Name.name_with_middle
  customer = connection.exec_prepared('create_customer', [
      customer_name,
      address_customer1,
      address_customer2,
      Time.now,
      Time.now
  ])[0]['id']
  customers.append(customer)

  users.append(connection.exec_prepared('create_user', [
      Faker::Internet.email(customer_name),
      '$2a$11$Px6tZ8kzukcjoDB3YgWqZ.ym2Sr2taWFVv.Xl0NWbq5bTcZLfgLcm',
      customer,
      Customer.name,
      Time.now,
      Time.now
  ])[0]['id'])
end

100000.times do
  # GENERATE BUSINESS

  # Create addresses for the business
  address_business1 = connection.exec_prepared('create_address', [
      Faker::Name.name_with_middle,
      Faker::Address.street_address,
      Faker::Address.city,
      Faker::Address.zip_code,
      Faker::Address.state,
      Faker::Address.country,
      Faker::PhoneNumber.cell_phone,
      Time.now,
      Time.now
  ])[0]['id']
  addresses.append(address_business1)

  address_business2 = connection.exec_prepared('create_address', [
      Faker::Name.name_with_middle,
      Faker::Address.street_address,
      Faker::Address.city,
      Faker::Address.zip_code,
      Faker::Address.state,
      Faker::Address.country,
      Faker::PhoneNumber.cell_phone,
      Time.now,
      Time.now
  ])[0]['id']
  addresses.append(address_business2)

  # Create the business
  business_created = Faker::Date.between(10.year.ago, Date.today)
  business = connection.exec_prepared('create_business', [
      address_business1,
      address_business2,
      Faker::Company.name,
      business_created,
      Time.now,
      Time.now
  ])[0]['id']
  businesses.append(business)

  # GENERATE BUSINESS OWNERS AND RELATIONSHIPS

  # Randomly generate the number of the business owners to create
  business_owners_count = 1 + Random.rand(9)
  business_owners_count.times do
    businesses_owner_name = Faker::Name.name_with_middle
    # Create addresses for the business
    address_business_owner1 = connection.exec_prepared('create_address', [
        businesses_owner_name,
        Faker::Address.street_address,
        Faker::Address.city,
        Faker::Address.zip_code,
        Faker::Address.state,
        Faker::Address.country,
        Faker::PhoneNumber.cell_phone,
        Time.now,
        Time.now
    ])[0]['id']
    addresses.append(address_business_owner1)

    address_business_owner2 = connection.exec_prepared('create_address', [
        businesses_owner_name,
        Faker::Address.street_address,
        Faker::Address.city,
        Faker::Address.zip_code,
        Faker::Address.state,
        Faker::Address.country,
        Faker::PhoneNumber.cell_phone,
        Time.now,
        Time.now
    ])[0]['id']
    addresses.append(address_business_owner2)

    business_owner = connection.exec_prepared('create_businessowner', [
        businesses_owner_name,
        address_business_owner1,
        address_business_owner2,
        Time.now,
        Time.now
    ])[0]['id']
    business_owners.append(business_owner)

    users.append(connection.exec_prepared('create_user', [
        Faker::Internet.email(businesses_owner_name),
        '$2a$11$Px6tZ8kzukcjoDB3YgWqZ.ym2Sr2taWFVv.Xl0NWbq5bTcZLfgLcm',
        business_owner,
        BusinessOwner.name,
        Time.now,
        Time.now
    ])[0]['id'])

    connection.exec_prepared('create_business_businessowner', [
        business,
        business_owner,
        Faker::Date.between(10.year.ago, 2.years.ago),
        Time.now,
        Time.now
    ])
  end

  # GENERATE EMPLOYEES AND RELATIONSHIPS
  employees = []
  # Randomly generate the number of the business services to create
  employees_count = business_owners_count + Random.rand(1000)
  employees_count.times do
    employee_name = Faker::Name.name_with_middle
    # Create addresses for the business
    address_employee1 = connection.exec_prepared('create_address', [
        employee_name,
        Faker::Address.street_address,
        Faker::Address.city,
        Faker::Address.zip_code,
        Faker::Address.state,
        Faker::Address.country,
        Faker::PhoneNumber.cell_phone,
        Time.now,
        Time.now
    ])[0]['id']
    addresses.append(address_employee1)

    address_employee2 = connection.exec_prepared('create_address', [
        employee_name,
        Faker::Address.street_address,
        Faker::Address.city,
        Faker::Address.zip_code,
        Faker::Address.state,
        Faker::Address.country,
        Faker::PhoneNumber.cell_phone,
        Time.now,
        Time.now
    ])[0]['id']
    addresses.append(address_employee2)

    employee = connection.exec_prepared('create_employee', [
        employee_name,
        business,
        address_employee1,
        address_employee2,
        Time.now,
        Time.now
    ])[0]['id']
    employees.append(employee)

    users.append(connection.exec_prepared('create_user', [
        Faker::Internet.email(employee_name),
        '$2a$11$Px6tZ8kzukcjoDB3YgWqZ.ym2Sr2taWFVv.Xl0NWbq5bTcZLfgLcm',
        employee,
        Employee.name,
        Time.now,
        Time.now
    ])[0]['id'])
  end


  # GENERATE BUSINESS SERVICES AND RELATIONSHIPS

  business_services = []
  # Randomly generate the number of the business services to create
  businesses_services_count =  10 + Random.rand(100)
  businesses_services_count.times do
    service_added = Faker::Date.between(business_created, Date.today)
    service = connection.exec_prepared('create_service', [
        Faker::Company.profession,
        Faker::Lorem.paragraph,
        service_added,
        Time.now,
        Time.now
    ])[0]['id']
    services.append(service)

    business_services.append(connection.exec_prepared('create_business_service', [
        business,
        service,
        Faker::Number.decimal(1 + Random.rand(3)),
        service_added,
        Time.now,
        Time.now
    ])[0]['id'])
  end

  # GENERATE ORDERS AND RELATIONSHIPS

  # Randomly generate the number of the orders to create
  order_services = []
  orders_count = Random.rand(1000)
  orders_count.times do
    order_created = Faker::Date.between(10.year.ago, Time.now)
    order = connection.exec_prepared('create_order', [
        customers[Random.rand(customers.length - 1)],
        order_created,
        Time.now,
        Time.now
    ])[0]['id']
    order_services_count = Random.rand(5)
    order_services_count.times do
      order_service = connection.exec_prepared('create_business_service_order', [
          business_services[Random.rand(business_services.length - 1)],
          order,
          Faker::Lorem.word,
          Faker::Lorem.paragraph,
          Faker::Date.between(order_created, Time.now),
          Time.now,
          Time.now
      ])[0]['id']
      order_services.append(order_service)
    end
  end
end

business_owners = BusinessOwner.all
businesses = Business.all
relationships = business_owners.count
while relationships > 0 do
  business_owner = business_owners[Random.rand(business_owners.count - 1)]
  business = businesses[Random.rand(businesses.count - 1)]

  if !business_owner.businesses.find_by(id: business.id)
    connection.exec_prepared('create_business_businessowner', [business.id, business_owner.id, Faker::Date.between(10.year.ago, Time.now), Time.now, Time.now])
    relationships -= 1
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

  connection.exec_prepared('create_document', [
      owner_type,
      owner,
      Faker::Lorem.word,
      "",
      Faker::Avatar.image,
      Faker::Lorem.paragraph,
      Time.now,
      Time.now
  ])
end
=end
=begin
connection = ActiveRecord::Base.connection.raw_connection
connection.prepare('create_user', 'INSERT INTO "users" ("email", "encrypted_password", "role_id", "role_type", "created_at", "updated_at") VALUES ($1, $2, $3, $4, $5, $6) RETURNING "id"')

#Administrator.all.select(:id, :email, :password_digest, :created_at, :updated_at).each {
#    |admin|
#  connection.exec_prepared('create_user', [ admin.email, admin.password_digest, admin.id,
#                                                 'Administrator', admin.created_at, admin.updated_at ])
#}
connection.exec_prepared('create_user', [ 4, "admin@test.com", '$2a$11$Px6tZ8kzukcjoDB3YgWqZ.ym2Sr2taWFVv.Xl0NWbq5bTcZLfgLcm', 2,
                                          'Administrator', Time.now, Time.now ])
connection.exec_prepared('create_user', [ 5, "davidmajercak@hotmail.com", '$2a$11$Px6tZ8kzukcjoDB3YgWqZ.ym2Sr2taWFVv.Xl0NWbq5bTcZLfgLcm', 3,
                                               'Administrator', Time.now, Time.now ])

BusinessOwner.all.select(:id, :email, :created_at, :updated_at).each {
    |business_owner|
  connection.exec_prepared('create_user', [ business_owner.email, '$2a$11$Px6tZ8kzukcjoDB3YgWqZ.ym2Sr2taWFVv.Xl0NWbq5bTcZLfgLcm', business_owner.id,
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

user = User.new
user.email = 'david1majercak@gmail.com'
user.encrypted_password='$2a$11$Px6tZ8kzukcjoDB3YgWqZ.ym2Sr2taWFVv.Xl0NWbq5bTcZLfgLcm'
user.role = Administrator.new
user.role.name = 'David Majercak'
user.role.save!
user.save!