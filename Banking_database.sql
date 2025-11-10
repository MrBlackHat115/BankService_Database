create database BankService;
use BankService;

CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE
);

INSERT INTO departments (department_name) VALUES
('Customer Service'),
('Loans'),
('Accounts'),
('IT'),
('HR'),
('Compliance'),
('Marketing'),
('Risk Management'),
('Finance'),
('Operations');

create table employees (
	id int auto_increment primary key not null,
    first_name varchar (50) not null,
    last_name varchar (50) not null,
    birth_date date,
    email varchar (250) not null,
    phone_number VARCHAR(15),
    address varchar (250) DEFAULT NULL,
    job_role varchar (250) not null,
    department_id INT,
    join_date timestamp default NOW(),
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

INSERT INTO employees (first_name, last_name, birth_date, email, phone_number, address, job_role, department_id)
VALUES
('John', 'Doe', '1985-03-15', 'jdoe@bank.com', '555-1111', '123 Main St', 'Teller', 1),
('Jane', 'Smith', '1990-07-22', 'jsmith@bank.com', '555-2222', '456 Oak Ave', 'Loan Officer', 2),
('Mike', 'Johnson', '1982-05-10', 'mjohnson@bank.com', '555-3333', '789 Pine Rd', 'Account Manager', 3),
('Sara', 'Williams', '1988-12-05', 'swilliams@bank.com', '555-4444', '321 Maple St', 'IT Support', 4),
('Robert', 'Brown', '1975-09-20', 'rbrown@bank.com', '555-5555', '654 Cedar Blvd', 'HR Manager', 5),
('Emily', 'Davis', '1992-11-11', 'edavis@bank.com', '555-6666', '987 Elm St', 'Compliance Officer', 6),
('James', 'Wilson', '1980-02-28', 'jwilson@bank.com', '555-7777', '246 Birch Ln', 'Marketing Specialist', 7),
('Laura', 'Moore', '1987-06-18', 'lmoore@bank.com', '555-8888', '135 Spruce Ct', 'Risk Analyst', 8),
('David', 'Taylor', '1991-01-30', 'dtaylor@bank.com', '555-9999', '864 Walnut Dr', 'Financial Analyst', 9),
('Anna', 'Anderson', '1983-08-25', 'aanderson@bank.com', '555-0000', '579 Chestnut Way', 'Operations Manager', 10);

create table clients (
	id int auto_increment primary key not null,
    first_name varchar (50) not null,
    last_name varchar (50) not null,
    birth_date date,
    email varchar (250) not null,
    phone_number VARCHAR(15),
    address varchar (250) DEFAULT NULL,
    join_date timestamp default NOW()
);

INSERT INTO clients (first_name, last_name, birth_date, email, phone_number, address)
VALUES
('Alice', 'Martin', '1990-01-01', 'alice.martin@email.com', '555-1001', '100 First St'),
('Bob', 'Clark', '1985-02-02', 'bob.clark@email.com', '555-1002', '200 Second St'),
('Carol', 'Lewis', '1992-03-03', 'carol.lewis@email.com', '555-1003', '300 Third St'),
('Dan', 'Walker', '1988-04-04', 'dan.walker@email.com', '555-1004', '400 Fourth St'),
('Eve', 'Hall', '1995-05-05', 'eve.hall@email.com', '555-1005', '500 Fifth St'),
('Frank', 'Allen', '1980-06-06', 'frank.allen@email.com', '555-1006', '600 Sixth St'),
('Grace', 'Young', '1993-07-07', 'grace.young@email.com', '555-1007', '700 Seventh St'),
('Hank', 'King', '1987-08-08', 'hank.king@email.com', '555-1008', '800 Eighth St'),
('Ivy', 'Wright', '1991-09-09', 'ivy.wright@email.com', '555-1009', '900 Ninth St'),
('Jack', 'Scott', '1984-10-10', 'jack.scott@email.com', '555-1010', '1000 Tenth St');

create table accounts (
	id int auto_increment primary key not null,
    photo VARCHAR(100) DEFAULT NULL,
	CheckingAccount DECIMAL(15,2) DEFAULT 0.00,
    SavingsAccount DECIMAL(15,2) DEFAULT 0.00,
    client_id int not null,
    created_date TIMESTAMP DEFAULT NOW(),
    foreign key (client_id) references clients(id)
);

INSERT INTO accounts (photo, CheckingAccount, SavingsAccount, client_id)
VALUES
(NULL, 1200.50, 5000.00, 1),
(NULL, 250.00, 1500.00, 2),
(NULL, 5000.00, 12000.00, 3),
(NULL, 300.00, 800.00, 4),
(NULL, 10000.00, 20000.00, 5),
(NULL, 750.00, 3000.00, 6),
(NULL, 1500.00, 4500.00, 7),
(NULL, 200.00, 1000.00, 8),
(NULL, 6000.00, 15000.00, 9),
(NULL, 900.00, 2500.00, 10);

-- Add an index to accounts.client_id for faster lookups
CREATE INDEX idx_accounts_client_id ON accounts(client_id);

create table transactions (
	id int auto_increment primary key not null,
	amount_sent DECIMAL(15,2) NOT NULL,
	sender_account_id INT NOT NULL,
    transaction_date TIMESTAMP DEFAULT NOW(),
	transaction_type ENUM('deposit','withdrawal','transfer','payment','fee','interest') NOT NULL, #ENUM is a data type that lets you define a column with a fixed set of possible values. Only one of these values can be stored in that column for each row.
    recipient_account_id INT,
    FOREIGN KEY (sender_account_id) REFERENCES accounts(id),
	FOREIGN KEY (recipient_account_id) REFERENCES accounts(id)
);

INSERT INTO transactions (amount_sent, sender_account_id, transaction_type, recipient_account_id)
VALUES
(200.00, 1, 'deposit', NULL),
(50.00, 2, 'withdrawal', NULL),
(500.00, 3, 'transfer', 4),
(100.00, 4, 'payment', 5),
(10.00, 5, 'fee', NULL),
(25.00, 6, 'interest', NULL),
(300.00, 7, 'transfer', 8),
(150.00, 8, 'deposit', NULL),
(400.00, 9, 'withdrawal', NULL),
(60.00, 10, 'payment', 1);

-- Add an index to transactions.sender_account_id for faster searches
CREATE INDEX idx_transactions_sender_account_id ON transactions(sender_account_id);

-- Add an index to transactions.recipient_account_id
CREATE INDEX idx_transactions_recipient_account_id ON transactions(recipient_account_id);

create table cards (
    id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT NOT NULL,
    card_number VARCHAR(16) NOT NULL UNIQUE,
    issue_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    expiration_date DATE GENERATED ALWAYS AS (DATE_ADD(issue_date, INTERVAL 3 YEAR)) STORED,
    cvv CHAR(3) NOT NULL,
    status ENUM('active', 'locked', 'expire', 'pending', 'canceled', 'stolen') DEFAULT 'active',
    FOREIGN KEY (account_id) REFERENCES accounts(id)
);

INSERT INTO cards (account_id, card_number, cvv, status)
VALUES
(1, '1111222233334441', '123', 'active'),
(2, '1111222233334442', '234', 'active'),
(3, '1111222233334443', '345', 'locked'),
(4, '1111222233334444', '456', 'expire'),
(5, '1111222233334445', '567', 'pending'),
(6, '1111222233334446', '678', 'canceled'),
(7, '1111222233334447', '789', 'stolen'),
(8, '1111222233334448', '890', 'active'),
(9, '1111222233334449', '901', 'locked'),
(10, '1111222233334450', '012', 'active');

-- Optional: index on cards.account_id if querying cards by account often
CREATE INDEX idx_cards_account_id ON cards(account_id);

CREATE TABLE franchise (
    franchise_id INT AUTO_INCREMENT PRIMARY KEY,
    franchise_name VARCHAR(100) NOT NULL UNIQUE,
    address VARCHAR(250),
    city VARCHAR(100),
    state VARCHAR(50),
    zip_code VARCHAR(10),
    phone_number VARCHAR(20),
    manager_id INT NULL,
    created_date TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (manager_id) REFERENCES employees(id)
);

INSERT INTO franchise (franchise_name, address, city, state, zip_code, phone_number, manager_id)
VALUES
('Downtown Branch', '10 Main St', 'Metropolis', 'NY', '10001', '555-2001', 1),
('Uptown Branch', '20 Oak St', 'Metropolis', 'NY', '10002', '555-2002', 2),
('Eastside Branch', '30 Pine St', 'Metropolis', 'NY', '10003', '555-2003', 3),
('Westside Branch', '40 Maple St', 'Metropolis', 'NY', '10004', '555-2004', 4),
('North Branch', '50 Cedar St', 'Metropolis', 'NY', '10005', '555-2005', 5),
('South Branch', '60 Elm St', 'Metropolis', 'NY', '10006', '555-2006', 6),
('Central Branch', '70 Birch St', 'Metropolis', 'NY', '10007', '555-2007', 7),
('Lakeview Branch', '80 Spruce St', 'Metropolis', 'NY', '10008', '555-2008', 8),
('Hilltop Branch', '90 Walnut St', 'Metropolis', 'NY', '10009', '555-2009', 9),
('Riverside Branch', '100 Chestnut St', 'Metropolis', 'NY', '10010', '555-2010', 10);

DELIMITER //

CREATE TRIGGER after_transaction_insert
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
    -- If transaction is a deposit, add to CheckingAccount
    IF NEW.transaction_type = 'deposit' THEN
        UPDATE accounts
        SET CheckingAccount = CheckingAccount + NEW.amount_sent
        WHERE id = NEW.sender_account_id;

    -- If transaction is a withdrawal, subtract from CheckingAccount
    ELSEIF NEW.transaction_type = 'withdrawal' THEN
        UPDATE accounts
        SET CheckingAccount = CheckingAccount - NEW.amount_sent
        WHERE id = NEW.sender_account_id;

    -- If transaction is a transfer, subtract from sender and add to recipient
    ELSEIF NEW.transaction_type = 'transfer' THEN
        UPDATE accounts
        SET CheckingAccount = CheckingAccount - NEW.amount_sent
        WHERE id = NEW.sender_account_id;

        UPDATE accounts
        SET CheckingAccount = CheckingAccount + NEW.amount_sent
        WHERE id = NEW.recipient_account_id;
    END IF;
END;
//

DELIMITER ;
    