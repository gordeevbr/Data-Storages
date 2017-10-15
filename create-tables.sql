\c ds_branch1;

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

\c ds_branch2;

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

\c ds_restore;

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

\c ds_central;

create table "branches" (
  "id" bigserial primary key,
  "number" bigserial not null
);

create table "results" (
  "id" bigserial primary key,
  "insertdate" timestamp not null,
  "createddate" timestamp not null,
  "paymentreceiveddate" timestamp,
  "completeddate" timestamp,
  "canceleddate" timestamp,
  "refunddate" timestamp
);

create table "products" (
  "id" bigserial primary key,
  "name" character varying(255) unique,
  "description" text,
  "price" numeric not null,
  "pricestartdate" timestamp not null,
  "category" varchar(255) not null,
  "manufacturer" varchar(255) not null,
  "manufacturerwebsite" varchar(255),
  "manufactureraddress" varchar(255)
);

create table "orders" (
  "id" bigserial primary key,
  "branchid" bigserial references branches (id),
  "resultid" bigserial references results (id),
  "productid" bigserial references products (id),
  "amount" smallint not null
);