---User Dropping/Creation---

drop user if exists ds_user;
create user ds_user with password 'ds_user_password';

---DB Dropping/Creation---

drop database if exists ds_branch1;
drop database if exists ds_branch2;
drop database if exists ds_central;
drop database if exists ds_restore;

create database ds_branch1 with owner ds_user;
create database ds_branch2 with owner ds_user;
create database ds_central with owner ds_user;
create database ds_restore with owner ds_user;

using ds_branch1;

create table "categories" (
  "id" bigserial primary key,
  "name" character varying(255) unique
);

create table "manufacturers" (
  "id" bigserial primary key,
  "name" character varying(255) unique,
  "website" character varying(255),
  "address" character varying(255)
);

create table "products" (
  "id" bigserial primary key,
  "name" character varying(255) unique,
  "description" text,
  "categoryid" bigserial references categories (id),
  "manufacturerid" bigserial references manufacturers (id)
);

create table "prices" (
  "id" bigserial primary key,
  "productid" bigserial references products (id),
  "value" numeric not null,
  "startdate" timestamp not null
);

create table "orders" (
  "id" bigserial primary key,
  "createddate" timestamp not null,
  "paymentreceiveddate" timestamp,
  "completeddate" timestamp,
  "canceleddate" timestamp,
  "refunddate" timestamp
);

create table "order_product" (
  "id" bigserial primary key,
  "productid" bigserial references products (id),
  "orderid" bigserial references orders (id),
  "amount" smallint not null
);

using ds_branch2;

create table "categories" (
  "id" bigserial primary key,
  "name" character varying(255) unique
);

create table "manufacturers" (
  "id" bigserial primary key,
  "name" character varying(255) unique,
  "website" character varying(255),
  "address" character varying(255)
);

create table "products" (
  "id" bigserial primary key,
  "name" character varying(255) unique,
  "description" text,
  "categoryid" bigserial references categories (id),
  "manufacturerid" bigserial references manufacturers (id)
);

create table "prices" (
  "id" bigserial primary key,
  "productid" bigserial references products (id),
  "value" numeric not null,
  "startdate" timestamp not null
);

create table "orders" (
  "id" bigserial primary key,
  "createddate" timestamp not null,
  "paymentreceiveddate" timestamp,
  "completeddate" timestamp,
  "canceleddate" timestamp,
  "refunddate" timestamp
);

create table "order_product" (
  "id" bigserial primary key,
  "productid" bigserial references products (id),
  "orderid" bigserial references orders (id),
  "amount" smallint not null
);

using ds_restore;

create table "categories" (
  "id" bigserial primary key,
  "name" character varying(255) unique
);

create table "manufacturers" (
  "id" bigserial primary key,
  "name" character varying(255) unique,
  "website" character varying(255),
  "address" character varying(255)
);

create table "products" (
  "id" bigserial primary key,
  "name" character varying(255) unique,
  "description" text,
  "categoryid" bigserial references categories (id),
  "manufacturerid" bigserial references manufacturers (id)
);

create table "prices" (
  "id" bigserial primary key,
  "productid" bigserial references products (id),
  "value" numeric not null,
  "startdate" timestamp not null
);

create table "orders" (
  "id" bigserial primary key,
  "createddate" timestamp not null,
  "paymentreceiveddate" timestamp,
  "completeddate" timestamp,
  "canceleddate" timestamp,
  "refunddate" timestamp
);

create table "order_product" (
  "id" bigserial primary key,
  "productid" bigserial references products (id),
  "orderid" bigserial references orders (id),
  "amount" smallint not null
);

