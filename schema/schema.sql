-- CREATE ADDRESSES

CREATE TABLE public.addresses
(
  id integer NOT NULL DEFAULT nextval('addresses_id_seq'::regclass),
  name character varying,
  street character varying,
  city character varying,
  "ZIP" character varying,
  state character varying,
  country character varying,
  phone character varying,
  created_at timestamp without time zone NOT NULL,
  updated_at timestamp without time zone NOT NULL,
  CONSTRAINT addresses_pkey PRIMARY KEY (id)
)

-- CREATE ADMINISTRATORS

CREATE TABLE public.administrators
(
  id integer NOT NULL DEFAULT nextval('administrators_id_seq'::regclass),
  email character varying,
  password_digest character varying,
  name character varying,
  created_at timestamp without time zone NOT NULL,
  updated_at timestamp without time zone NOT NULL,
  CONSTRAINT administrators_pkey PRIMARY KEY (id)
)

-- CREATE BUSINESS_BUSINESS_OWNERS

CREATE TABLE public.business_business_owners
(
  id integer NOT NULL DEFAULT nextval('business_business_owners_id_seq'::regclass),
  business_id integer,
  business_owner_id integer,
  date_from timestamp without time zone,
  date_to timestamp without time zone,
  created_at timestamp without time zone NOT NULL,
  updated_at timestamp without time zone NOT NULL,
  CONSTRAINT business_business_owners_pkey PRIMARY KEY (id),
  CONSTRAINT fk_rails_b7cd7d9601 FOREIGN KEY (business_owner_id)
      REFERENCES public.business_owners (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_rails_bbc8cb22a7 FOREIGN KEY (business_id)
      REFERENCES public.businesses (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)

-- CREATE BUSINESS_OWNERS

CREATE TABLE public.business_owners
(
  id integer NOT NULL DEFAULT nextval('business_owners_id_seq'::regclass),
  billing_address_id integer,
  shipping_address_id integer,
  email character varying,
  password_digest character varying,
  name character varying,
  created_at timestamp without time zone NOT NULL,
  updated_at timestamp without time zone NOT NULL,
  CONSTRAINT business_owners_pkey PRIMARY KEY (id),
  CONSTRAINT fk_rails_4e64f56332 FOREIGN KEY (billing_address_id)
      REFERENCES public.addresses (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_rails_edd0da4938 FOREIGN KEY (shipping_address_id)
      REFERENCES public.addresses (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)

-- CREATE SERVICE_ORDERS

CREATE TABLE public.business_service_orders
(
  id integer NOT NULL DEFAULT nextval('business_service_orders_id_seq'::regclass),
  business_service_id integer,
  order_id integer,
  label character varying,
  description text,
  date_created timestamp without time zone,
  created_at timestamp without time zone NOT NULL,
  updated_at timestamp without time zone NOT NULL,
  CONSTRAINT business_service_orders_pkey PRIMARY KEY (id),
  CONSTRAINT fk_rails_37675b4c55 FOREIGN KEY (order_id)
      REFERENCES public.orders (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_rails_784f461bc6 FOREIGN KEY (business_service_id)
      REFERENCES public.business_services (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)

-- CREATE BUSINESS_SERVICES

CREATE TABLE public.business_services
(
  id integer NOT NULL DEFAULT nextval('business_services_id_seq'::regclass),
  business_id integer,
  service_id integer,
  price numeric,
  date_added timestamp without time zone,
  created_at timestamp without time zone NOT NULL,
  updated_at timestamp without time zone NOT NULL,
  CONSTRAINT business_services_pkey PRIMARY KEY (id),
  CONSTRAINT fk_rails_72f9ec7c1a FOREIGN KEY (business_id)
      REFERENCES public.businesses (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_rails_f4b20ffb6f FOREIGN KEY (service_id)
      REFERENCES public.services (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)

-- CREATE BUSINESSES

CREATE TABLE public.businesses
(
  id integer NOT NULL DEFAULT nextval('businesses_id_seq'::regclass),
  billing_address_id integer,
  shipping_address_id integer,
  administrator_id integer,
  name character varying,
  date_joined timestamp without time zone,
  created_at timestamp without time zone NOT NULL,
  updated_at timestamp without time zone NOT NULL,
  CONSTRAINT businesses_pkey PRIMARY KEY (id),
  CONSTRAINT fk_rails_65cb118748 FOREIGN KEY (shipping_address_id)
      REFERENCES public.addresses (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_rails_bdc5efd4e6 FOREIGN KEY (billing_address_id)
      REFERENCES public.addresses (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_rails_da95b6171c FOREIGN KEY (administrator_id)
      REFERENCES public.administrators (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)

-- CREATE CUSTOMERS

CREATE TABLE public.customers
(
  id integer NOT NULL DEFAULT nextval('customers_id_seq'::regclass),
  billing_address_id integer,
  shipping_address_id integer,
  email character varying,
  password_digest character varying,
  name character varying,
  date_joined timestamp without time zone,
  created_at timestamp without time zone NOT NULL,
  updated_at timestamp without time zone NOT NULL,
  CONSTRAINT customers_pkey PRIMARY KEY (id),
  CONSTRAINT fk_rails_3e25052ad1 FOREIGN KEY (shipping_address_id)
      REFERENCES public.addresses (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_rails_9753dc5339 FOREIGN KEY (billing_address_id)
      REFERENCES public.addresses (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)

-- CREATE DOCUMENTS

REATE TABLE public.documents
(
  id integer NOT NULL DEFAULT nextval('documents_id_seq'::regclass),
  documentable_type character varying,
  documentable_id integer,
  label character varying,
  data bytea,
  dataurl text,
  description text,
  created_at timestamp without time zone NOT NULL,
  updated_at timestamp without time zone NOT NULL,
  CONSTRAINT documents_pkey PRIMARY KEY (id)
)

-- CREATE EMPLOYEES

CREATE TABLE public.employees
(
  id integer NOT NULL DEFAULT nextval('employees_id_seq'::regclass),
  business_id integer,
  billing_address_id integer,
  shipping_address_id integer,
  email character varying,
  password_digest character varying,
  name character varying,
  created_at timestamp without time zone NOT NULL,
  updated_at timestamp without time zone NOT NULL,
  CONSTRAINT employees_pkey PRIMARY KEY (id),
  CONSTRAINT fk_rails_17ed137b05 FOREIGN KEY (shipping_address_id)
      REFERENCES public.addresses (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_rails_66e61fc4e7 FOREIGN KEY (billing_address_id)
      REFERENCES public.addresses (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_rails_e19aaeae53 FOREIGN KEY (business_id)
      REFERENCES public.businesses (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)

-- CREATE ORDERS

CREATE TABLE public.orders
(
  id integer NOT NULL DEFAULT nextval('orders_id_seq'::regclass),
  customer_id integer,
  date_created timestamp without time zone,
  created_at timestamp without time zone NOT NULL,
  updated_at timestamp without time zone NOT NULL,
  CONSTRAINT orders_pkey PRIMARY KEY (id),
  CONSTRAINT fk_rails_3dad120da9 FOREIGN KEY (customer_id)
      REFERENCES public.customers (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)

-- CREATE SERVICES

CREATE TABLE public.services
(
  id integer NOT NULL DEFAULT nextval('services_id_seq'::regclass),
  label character varying,
  description text,
  date_added timestamp without time zone,
  created_at timestamp without time zone NOT NULL,
  updated_at timestamp without time zone NOT NULL,
  CONSTRAINT services_pkey PRIMARY KEY (id)
)