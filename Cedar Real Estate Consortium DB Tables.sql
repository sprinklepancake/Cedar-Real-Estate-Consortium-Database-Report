CREATE DATABASE IF NOT EXISTS project;
USE project;

CREATE TABLE IF NOT EXISTS agency (
  agency_ID INT AUTO_INCREMENT PRIMARY KEY,
  email CHAR(40) NOT NULL,
  name CHAR(100) NOT NULL,
  address CHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS phone_nmbs (
  agency_ID INT,
  phone_nmbs CHAR(8) NOT NULL,
  FOREIGN KEY (agency_ID) REFERENCES agency(agency_ID),
  UNIQUE KEY unique_phone_number (phone_nmbs)
);

CREATE TABLE IF NOT EXISTS branch (
  branch_ID INT AUTO_INCREMENT PRIMARY KEY,
  agency_ID INT,
  phone_nmb CHAR(8) NOT NULL,
  address CHAR(255) NOT NULL,
  FOREIGN KEY (agency_ID) REFERENCES agency(agency_ID),
  UNIQUE KEY unique_phone_number (phone_nmb)
);

CREATE TABLE IF NOT EXISTS department (
  dep_ID INT AUTO_INCREMENT PRIMARY KEY,
  branch_ID INT NOT NULL,
  name CHAR(100) NOT NULL,
  location CHAR(255) NOT NULL,
  FOREIGN KEY (branch_ID) REFERENCES branch(branch_ID)
);

CREATE TABLE IF NOT EXISTS manager (
  manager_ID INT AUTO_INCREMENT PRIMARY KEY,
  dep_ID INT NOT NULL,
  name CHAR(255) NOT NULL,
  gender CHAR(255),
  salary INT DEFAULT 50000,
  FOREIGN KEY (dep_ID) REFERENCES department(dep_ID)
);

CREATE TABLE IF NOT EXISTS agent (
  agent_ID INT AUTO_INCREMENT PRIMARY KEY,
  agency_ID INT NOT NULL,
  percentage_taken INT DEFAULT 10,
  name CHAR(100) NOT NULL,
  email CHAR(40) NOT NULL,
  license INT,
  salary INT DEFAULT 70000,
  FOREIGN KEY (agency_ID) REFERENCES agency(agency_ID)
);

CREATE TABLE IF NOT EXISTS maintenance_company (
  maintenance_ID INT AUTO_INCREMENT PRIMARY KEY,
  cost INT NOT NULL,
  description CHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS owner (
  registration_number INT AUTO_INCREMENT PRIMARY KEY,
  agent_ID INT NOT NULL,
  phone_nmb CHAR(8) NOT NULL,
  name CHAR(255) NOT NULL,
  FOREIGN KEY (agent_ID) REFERENCES agent(agent_ID),
  UNIQUE KEY unique_phone_number (phone_nmb)
);

CREATE TABLE IF NOT EXISTS property (
  property_ID INT AUTO_INCREMENT PRIMARY KEY,
  registration_number INT,
  maintenance_ID INT,
  address CHAR(255) NOT NULL,
  size INT,
  date_listed DATE,
  type ENUM('for_sale', 'for_rent'),
  price INT,
  monthly_rent INT,
  FOREIGN KEY (maintenance_ID) REFERENCES maintenance_company(maintenance_ID),
  FOREIGN KEY (registration_number) REFERENCES owner(registration_number)
);

CREATE TABLE IF NOT EXISTS bank_account (
  bank_acc_ID INT AUTO_INCREMENT PRIMARY KEY,
  pin INT NOT NULL,
  name CHAR(100) NOT NULL,
  credit_score INT DEFAULT 500
);

CREATE TABLE IF NOT EXISTS old_client (
  client_ID INT PRIMARY KEY,
  bank_acc_ID INT NOT NULL,
  property_ID INT,
  phone_number CHAR(8) NOT NULL,
  email CHAR(40) NOT NULL,
  name CHAR(100) NOT NULL,
  stay_length INT DEFAULT 1,
  FOREIGN KEY (property_ID) REFERENCES property(property_ID),
  FOREIGN KEY (bank_acc_ID) REFERENCES bank_account(bank_acc_ID),
  UNIQUE KEY unique_phone_number (phone_number)
);
CREATE TABLE IF NOT EXISTS new_client (
  client_ID INT PRIMARY KEY,
  bank_acc_ID INT NOT NULL,
  property_picked CHAR(20),
  phone_number CHAR(8) NOT NULL,
  email CHAR(40) NOT NULL,
  name CHAR(100) NOT NULL,
  budget INT,
  app_date DATE,
  app_time TIME,
  FOREIGN KEY (bank_acc_ID) REFERENCES bank_account(bank_acc_ID),
  UNIQUE KEY unique_phone_number (phone_number)
);

CREATE TABLE IF NOT EXISTS payment (
  pay_ID INT AUTO_INCREMENT PRIMARY KEY,
  agent_ID INT NOT NULL,
  client_ID INT NOT NULL,
  bank_acc_ID INT NOT NULL,
  total_amount INT NOT NULL,
  pay_date DATE,
  method ENUM('card','cash'),
  FOREIGN KEY (agent_ID) REFERENCES agent(agent_ID),
  FOREIGN KEY (client_ID) REFERENCES new_client(client_ID),
  FOREIGN KEY (bank_acc_ID) REFERENCES bank_account(bank_acc_ID)
);

CREATE TABLE IF NOT EXISTS review (
  review_ID INT AUTO_INCREMENT PRIMARY KEY,
  property_ID INT NOT NULL,
  client_ID INT NOT NULL,
  rating INT CHECK (rating >= 1 AND rating <= 5),
  FOREIGN KEY (property_ID) REFERENCES property(property_ID),
  FOREIGN KEY (client_ID) REFERENCES old_client(client_ID)
);

CREATE TABLE IF NOT EXISTS contract (
  cntr_ID INT AUTO_INCREMENT PRIMARY KEY,
  property_ID INT NOT NULL,
  FOREIGN KEY (property_ID) REFERENCES property(property_ID)
);
