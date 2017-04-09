--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.2
-- Dumped by pg_dump version 9.6.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: addresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE addresses (
    id integer NOT NULL,
    name character varying,
    street character varying,
    city character varying,
    "ZIP" character varying,
    state character varying,
    country character varying,
    phone character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE addresses_id_seq OWNED BY addresses.id;


--
-- Name: administrators; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE administrators (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: administrators_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE administrators_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: administrators_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE administrators_id_seq OWNED BY administrators.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: business_business_owners; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE business_business_owners (
    id integer NOT NULL,
    business_id integer,
    business_owner_id integer,
    date_from timestamp without time zone,
    date_to timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: business_business_owners_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE business_business_owners_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: business_business_owners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE business_business_owners_id_seq OWNED BY business_business_owners.id;


--
-- Name: business_owners; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE business_owners (
    id integer NOT NULL,
    billing_address_id integer,
    shipping_address_id integer,
    email character varying,
    password_digest character varying,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: business_owners_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE business_owners_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: business_owners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE business_owners_id_seq OWNED BY business_owners.id;


--
-- Name: business_service_orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE business_service_orders (
    id integer NOT NULL,
    business_service_id integer,
    order_id integer,
    label character varying,
    description text,
    date_created timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: business_service_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE business_service_orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: business_service_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE business_service_orders_id_seq OWNED BY business_service_orders.id;


--
-- Name: business_services; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE business_services (
    id integer NOT NULL,
    business_id integer,
    service_id integer,
    price numeric,
    date_added timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: business_services_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE business_services_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: business_services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE business_services_id_seq OWNED BY business_services.id;


--
-- Name: businesses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE businesses (
    id integer NOT NULL,
    billing_address_id integer,
    shipping_address_id integer,
    administrator_id integer,
    name character varying,
    date_joined timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: businesses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE businesses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: businesses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE businesses_id_seq OWNED BY businesses.id;


--
-- Name: customers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE customers (
    id integer NOT NULL,
    billing_address_id integer,
    shipping_address_id integer,
    email character varying,
    password_digest character varying,
    name character varying,
    date_joined timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: customers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE customers_id_seq OWNED BY customers.id;


--
-- Name: documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE documents (
    id integer NOT NULL,
    documentable_type character varying,
    documentable_id integer,
    label character varying,
    data bytea,
    dataurl text,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE documents_id_seq OWNED BY documents.id;


--
-- Name: employees; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE employees (
    id integer NOT NULL,
    business_id integer,
    billing_address_id integer,
    shipping_address_id integer,
    email character varying,
    password_digest character varying,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: employees_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE employees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: employees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE employees_id_seq OWNED BY employees.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE orders (
    id integer NOT NULL,
    customer_id integer,
    date_created timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE orders_id_seq OWNED BY orders.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: services; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE services (
    id integer NOT NULL,
    label character varying,
    description text,
    date_added timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: services_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE services_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE services_id_seq OWNED BY services.id;


--
-- Name: addresses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY addresses ALTER COLUMN id SET DEFAULT nextval('addresses_id_seq'::regclass);


--
-- Name: administrators id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY administrators ALTER COLUMN id SET DEFAULT nextval('administrators_id_seq'::regclass);


--
-- Name: business_business_owners id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY business_business_owners ALTER COLUMN id SET DEFAULT nextval('business_business_owners_id_seq'::regclass);


--
-- Name: business_owners id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY business_owners ALTER COLUMN id SET DEFAULT nextval('business_owners_id_seq'::regclass);


--
-- Name: business_service_orders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY business_service_orders ALTER COLUMN id SET DEFAULT nextval('business_service_orders_id_seq'::regclass);


--
-- Name: business_services id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY business_services ALTER COLUMN id SET DEFAULT nextval('business_services_id_seq'::regclass);


--
-- Name: businesses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY businesses ALTER COLUMN id SET DEFAULT nextval('businesses_id_seq'::regclass);


--
-- Name: customers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY customers ALTER COLUMN id SET DEFAULT nextval('customers_id_seq'::regclass);


--
-- Name: documents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY documents ALTER COLUMN id SET DEFAULT nextval('documents_id_seq'::regclass);


--
-- Name: employees id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY employees ALTER COLUMN id SET DEFAULT nextval('employees_id_seq'::regclass);


--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY orders ALTER COLUMN id SET DEFAULT nextval('orders_id_seq'::regclass);


--
-- Name: services id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY services ALTER COLUMN id SET DEFAULT nextval('services_id_seq'::regclass);


--
-- Name: addresses addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- Name: administrators administrators_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY administrators
    ADD CONSTRAINT administrators_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: business_business_owners business_business_owners_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY business_business_owners
    ADD CONSTRAINT business_business_owners_pkey PRIMARY KEY (id);


--
-- Name: business_owners business_owners_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY business_owners
    ADD CONSTRAINT business_owners_pkey PRIMARY KEY (id);


--
-- Name: business_service_orders business_service_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY business_service_orders
    ADD CONSTRAINT business_service_orders_pkey PRIMARY KEY (id);


--
-- Name: business_services business_services_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY business_services
    ADD CONSTRAINT business_services_pkey PRIMARY KEY (id);


--
-- Name: businesses businesses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY businesses
    ADD CONSTRAINT businesses_pkey PRIMARY KEY (id);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- Name: documents documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: services services_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY services
    ADD CONSTRAINT services_pkey PRIMARY KEY (id);


--
-- Name: index_business_business_owners_on_business_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_business_business_owners_on_business_id ON business_business_owners USING btree (business_id);


--
-- Name: index_business_business_owners_on_business_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_business_business_owners_on_business_owner_id ON business_business_owners USING btree (business_owner_id);


--
-- Name: index_business_owners_on_billing_address_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_business_owners_on_billing_address_id ON business_owners USING btree (billing_address_id);


--
-- Name: index_business_owners_on_shipping_address_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_business_owners_on_shipping_address_id ON business_owners USING btree (shipping_address_id);


--
-- Name: index_business_service_orders_on_business_service_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_business_service_orders_on_business_service_id ON business_service_orders USING btree (business_service_id);


--
-- Name: index_business_service_orders_on_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_business_service_orders_on_order_id ON business_service_orders USING btree (order_id);


--
-- Name: index_business_services_on_business_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_business_services_on_business_id ON business_services USING btree (business_id);


--
-- Name: index_business_services_on_service_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_business_services_on_service_id ON business_services USING btree (service_id);


--
-- Name: index_businesses_on_administrator_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_businesses_on_administrator_id ON businesses USING btree (administrator_id);


--
-- Name: index_businesses_on_billing_address_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_businesses_on_billing_address_id ON businesses USING btree (billing_address_id);


--
-- Name: index_businesses_on_shipping_address_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_businesses_on_shipping_address_id ON businesses USING btree (shipping_address_id);


--
-- Name: index_customers_on_billing_address_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_customers_on_billing_address_id ON customers USING btree (billing_address_id);


--
-- Name: index_customers_on_shipping_address_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_customers_on_shipping_address_id ON customers USING btree (shipping_address_id);


--
-- Name: index_documents_on_documentable_id_and_documentable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_documents_on_documentable_id_and_documentable_type ON documents USING btree (documentable_id, documentable_type);


--
-- Name: index_documents_on_documentable_type_and_documentable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_documents_on_documentable_type_and_documentable_id ON documents USING btree (documentable_type, documentable_id);


--
-- Name: index_employees_on_billing_address_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_employees_on_billing_address_id ON employees USING btree (billing_address_id);


--
-- Name: index_employees_on_business_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_employees_on_business_id ON employees USING btree (business_id);


--
-- Name: index_employees_on_shipping_address_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_employees_on_shipping_address_id ON employees USING btree (shipping_address_id);


--
-- Name: index_orders_on_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_orders_on_customer_id ON orders USING btree (customer_id);


--
-- Name: employees fk_rails_17ed137b05; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY employees
    ADD CONSTRAINT fk_rails_17ed137b05 FOREIGN KEY (shipping_address_id) REFERENCES addresses(id);


--
-- Name: business_service_orders fk_rails_37675b4c55; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY business_service_orders
    ADD CONSTRAINT fk_rails_37675b4c55 FOREIGN KEY (order_id) REFERENCES orders(id);


--
-- Name: orders fk_rails_3dad120da9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT fk_rails_3dad120da9 FOREIGN KEY (customer_id) REFERENCES customers(id);


--
-- Name: customers fk_rails_3e25052ad1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY customers
    ADD CONSTRAINT fk_rails_3e25052ad1 FOREIGN KEY (shipping_address_id) REFERENCES addresses(id);


--
-- Name: business_owners fk_rails_4e64f56332; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY business_owners
    ADD CONSTRAINT fk_rails_4e64f56332 FOREIGN KEY (billing_address_id) REFERENCES addresses(id);


--
-- Name: businesses fk_rails_65cb118748; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY businesses
    ADD CONSTRAINT fk_rails_65cb118748 FOREIGN KEY (shipping_address_id) REFERENCES addresses(id);


--
-- Name: employees fk_rails_66e61fc4e7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY employees
    ADD CONSTRAINT fk_rails_66e61fc4e7 FOREIGN KEY (billing_address_id) REFERENCES addresses(id);


--
-- Name: business_services fk_rails_72f9ec7c1a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY business_services
    ADD CONSTRAINT fk_rails_72f9ec7c1a FOREIGN KEY (business_id) REFERENCES businesses(id);


--
-- Name: business_service_orders fk_rails_784f461bc6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY business_service_orders
    ADD CONSTRAINT fk_rails_784f461bc6 FOREIGN KEY (business_service_id) REFERENCES business_services(id);


--
-- Name: customers fk_rails_9753dc5339; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY customers
    ADD CONSTRAINT fk_rails_9753dc5339 FOREIGN KEY (billing_address_id) REFERENCES addresses(id);


--
-- Name: business_business_owners fk_rails_b7cd7d9601; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY business_business_owners
    ADD CONSTRAINT fk_rails_b7cd7d9601 FOREIGN KEY (business_owner_id) REFERENCES business_owners(id);


--
-- Name: business_business_owners fk_rails_bbc8cb22a7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY business_business_owners
    ADD CONSTRAINT fk_rails_bbc8cb22a7 FOREIGN KEY (business_id) REFERENCES businesses(id);


--
-- Name: businesses fk_rails_bdc5efd4e6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY businesses
    ADD CONSTRAINT fk_rails_bdc5efd4e6 FOREIGN KEY (billing_address_id) REFERENCES addresses(id);


--
-- Name: businesses fk_rails_da95b6171c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY businesses
    ADD CONSTRAINT fk_rails_da95b6171c FOREIGN KEY (administrator_id) REFERENCES administrators(id);


--
-- Name: employees fk_rails_e19aaeae53; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY employees
    ADD CONSTRAINT fk_rails_e19aaeae53 FOREIGN KEY (business_id) REFERENCES businesses(id);


--
-- Name: business_owners fk_rails_edd0da4938; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY business_owners
    ADD CONSTRAINT fk_rails_edd0da4938 FOREIGN KEY (shipping_address_id) REFERENCES addresses(id);


--
-- Name: business_services fk_rails_f4b20ffb6f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY business_services
    ADD CONSTRAINT fk_rails_f4b20ffb6f FOREIGN KEY (service_id) REFERENCES services(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20170310165936'),
('20170318212838'),
('20170318214333'),
('20170319090453'),
('20170319120932'),
('20170319122403'),
('20170319122726'),
('20170319123523'),
('20170319123652'),
('20170319123928'),
('20170319125141'),
('20170319125328');


