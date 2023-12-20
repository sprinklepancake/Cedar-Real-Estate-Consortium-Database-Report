#BASIC SQL QUERIES

#queries are separated by a line of  "#"

#cartesian
SELECT * FROM branch, agency;

#################################################################################################################################################################################################################

#natural join
SELECT * FROM agency NATURAL JOIN phone_nmbs;

#################################################################################################################################################################################################################

#theta join using "USING"
SELECT * FROM branch JOIN department USING (branch_ID);		#gives us each branch and its departments

#################################################################################################################################################################################################################

#theta join using ON
SELECT * FROM department JOIN manager ON department.dep_ID = manager.dep_ID;	#gives us the manager for each department by matching the dep_ID in the departments table to dep_ID in the managers table

#################################################################################################################################################################################################################

#self join
SELECT a.name AS agent, b.name AS same_email, a.email
FROM agent a, agent b
WHERE a.email = b.email AND a.agent_ID <> b.agent_ID;		#gives us all the agents who have the same email

#################################################################################################################################################################################################################

#disinct
SELECT DISTINCT maintenance_ID FROM property;	#gives us all the maintenance companies that are being contracted

#################################################################################################################################################################################################################

#like keyword
SELECT * FROM owner WHERE name LIKE '%Haddad';		#adjusted some owners to have same family name so this query can show results better

#################################################################################################################################################################################################################

#order by
SELECT * FROM property ORDER BY size DESC;	#sorts properties by size (can do for price and monthly rent)

#################################################################################################################################################################################################################

#union
SELECT name FROM old_client
UNION
SELECT name FROM new_client;		#joins all the cients and displays their names

#################################################################################################################################################################################################################

#intersect
#SELECT email FROM old_client INTERSECT SELECT email FROM new_client;
#this doesnt work in mysql but you can achieve the same result using the following code:

#MySQL equivalent:

SELECT DISTINCT old_client.email
FROM old_client
INNER JOIN new_client ON old_client.email = new_client.email;	#modified a new client and an old client to have the same email so this can produce a result
#shows the data that is present in both tables
#to check which clients have the same email to contact them on their distinct phone numbers

#################################################################################################################################################################################################################

#except
#SELECT name FROM old_client EXCEPT SELECT name FROM new_client;
#also not supported by mysql but can be achieved by the following code:

#MySQL equivalent:

SELECT DISTINCT old_client.email
FROM old_client
LEFT JOIN new_client ON old_client.email = new_client.email
WHERE new_client.email IS NULL;			#here we have the email "client1@example.com" present in both table so it doesnt show up in the result for this query
#to get the emails only present in old_client

#################################################################################################################################################################################################################

#count Aggregate function without GROUP BY
SELECT COUNT(*) AS row_count FROM property;	#to get how many properties there is in the database

#################################################################################################################################################################################################################

#count Grouping aggregate function (with GROUP BY)
SELECT agency_ID, COUNT(*) AS count_of_agents FROM agent GROUP BY agency_ID;		#shows count of each data value
#shows us how many agents work for each agency

#################################################################################################################################################################################################################

#Grouping aggregate function with condition (with GROUP BY and HAVING)
SELECT branch_ID, COUNT(*) AS count_of_deps FROM department GROUP BY branch_ID HAVING COUNT(*) > 2;	#we have branch ID "1" present 3 times in the database, and the query shows the branch IDs that are present >2 times
#shows us the count of departments each branch of more than 2 departments has

#################################################################################################################################################################################################################

select * from manager where name like  '%khassuna%';
select * from manager where name like '%Tamer%';

#just testing out the queries

#################################################################################################################################################################################################################

SELECT CURDATE() AS today;	#gives the current date

#################################################################################################################################################################################################################

#SELECT column1, CASE WHEN condition THEN 'Value1' ELSE 'Value2' END AS alias_name FROM table1;

SELECT * FROM property WHERE monthly_rent IS NULL;			#this gives the properties that hava monthly rent as NULL (aka the properties that are for sale)
SELECT * FROM property WHERE monthly_rent IS NOT NULL;		#this gives all the properties that have monthly rent (aka the properties that are for sale)
SELECT * FROM property WHERE type LIKE 'for_sale';		#this gives the properties that are for sale by checking the type of the property rather than the monthly rent

#################################################################################################################################################################################################################

SELECT * FROM payment LIMIT 10; #retrieves the first 10 rows



#################################################################################################################################################################################################################
#################################################################################################################################################################################################################
#################################################################################################################################################################################################################
#################################################################################################################################################################################################################
#################################################################################################################################################################################################################
#################################################################################################################################################################################################################
#################################################################################################################################################################################################################
#################################################################################################################################################################################################################
#################################################################################################################################################################################################################
#################################################################################################################################################################################################################
#################################################################################################################################################################################################################
#################################################################################################################################################################################################################
#################################################################################################################################################################################################################
#################################################################################################################################################################################################################
#################################################################################################################################################################################################################
#################################################################################################################################################################################################################
#################################################################################################################################################################################################################
#################################################################################################################################################################################################################
#################################################################################################################################################################################################################


#ADVANCED SQL QUERIES



#set membership nested query
SELECT a.name 
FROM agent a
WHERE a.agent_ID IN (SELECT p.agent_ID FROM payment p WHERE method='cash');

#################################################################################################################################################################################################################

#set comparison nested query
SELECT p.agent_ID
FROM payment p
WHERE p.total_amount>ANY (SELECT p2.total_amount FROM payment p2 WHERE p2.agent_ID=2);

#################################################################################################################################################################################################################

#set cardinality nested query
SELECT COUNT(*)
FROM property
WHERE registration_number IN(SELECT registration_number FROM owner WHERE name='Fadi Haddad');

#################################################################################################################################################################################################################

#two or more nesting levels
SELECT d.name
FROM department d
WHERE d.branch_ID IN(SELECT b.branch_ID FROM branch b WHERE b.agency_ID NOT IN(SELECT agency_ID FROM agency WHERE address='Beirut,Lebanon'));

#################################################################################################################################################################################################################

#division operation 
#not suppoerted by mysql
#SELECT a.email
#FROM agent a
#WHERE NOT EXISTS((SELECT p.registration_number FROM property) EXCEPT (SELECT o.registration_number FROM owner o WHERE o.agent_ID=a.agent_ID));

#MYSQL equivalent
SELECT a.email
FROM agent a
WHERE NOT EXISTS (
    SELECT p.registration_number 
    FROM property p
    LEFT JOIN owner o ON p.registration_number = o.registration_number
                      AND o.agent_ID = a.agent_ID
    WHERE o.registration_number IS NOT NULL
);

#################################################################################################################################################################################################################

#nested query in the FROM statement
SELECT AVG(sum_amount) AS avg_amount
FROM(SELECT client_ID,SUM(p.total_amount) AS sum_amount FROM payment p GROUP BY client_ID)AS sum_payment;

#################################################################################################################################################################################################################

#nested query in the SELECT statement 
SELECT client_ID, name, email, (SELECT SUM(total_amount) FROM payment p WHERE p.client_ID=old_client.client_ID) AS sum_amount
FROM old_client;

#################################################################################################################################################################################################################

#UPDATE query that contains a “CASE” statement 
UPDATE agent
SET salary=CASE
WHEN salary>=47000 THEN salary*1.10
WHEN salary<=43000 THEN salary*1.05
ELSE salary*1.07
END;

#################################################################################################################################################################################################################

#OUTER JOIN 
SELECT p.registration_number, p.address, p.type, p.price, r.rating
FROM property p
LEFT OUTER JOIN review r ON p.registration_number = r.property_ID;

#################################################################################################################################################################################################################

#CREATE ASSERTION
#not supported by mysql
#CREATE ASSERTION manager_department
#CHECK(NOT EXISTS(SELECT * FROM manager m WHERE NO EXISTS(SELECT * FROM department d WHERE m.dep_ID=d.dep_ID)));

#MySQL version of it:
DELIMITER //

CREATE TRIGGER manager_department_trigger
BEFORE INSERT ON manager
FOR EACH ROW
BEGIN
    DECLARE depExists INT;
    SELECT COUNT(*) INTO depExists FROM department WHERE dep_ID = NEW.dep_ID;
    
    IF depExists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid dep_ID: Department does not exist';
    END IF;
END//

DELIMITER ;

#################################################################################################################################################################################################################

#CREATE VIEW
CREATE VIEW acc_details(bank_acc_ID,name,credit_score) AS
SELECT bank_acc_ID,name,credit_score
FROM bank_account;

#################################################################################################################################################################################################################

#CREATE TRIGGER
CREATE TRIGGER updatePropertyCount
AFTER INSERT ON property 
FOR EACH ROW
UPDATE CountProperties
SET count = count + 1
WHERE property_type = NEW.type AND address= NEW.address;

#################################################################################################################################################################################################################

#CREATE FUNCTION

DELIMITER //

CREATE FUNCTION CalculateMaintenanceCost(propertyID INT) RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE totalCost DECIMAL(10, 2);
    SELECT SUM(cost) INTO totalCost FROM maintenance WHERE maintenance_ID IN (
        SELECT maintenance_ID FROM property WHERE registration_number = propertyID
    );
    RETURN totalCost;
END//

DELIMITER ;

#This function CalculateMaintenanceCost takes a property ID as input and calculates the total cost of maintenance associated with that property. It retrieves the sum of the maintenance costs related to the specified property by joining the property and maintenance tables

#################################################################################################################################################################################################################

#CREATE PROCEDURE
DELIMITER //
CREATE PROCEDURE CountPropertiesForSaleOrRent(IN type CHAR ,OUT saleCount INT,OUT rentCount INT)
BEGIN
DECLARE saleCount INT;
DECLARE rentCount INT;
SELECT COUNT(*) INTO saleCount FROM property WHERE type = 'for_sale';
SELECT COUNT(*) INTO rentCount FROM property WHERE type = 'for_rent';
SELECT saleCount AS 'Properties_For_Sale', rentCount AS 'Properties_For_Rent';
END;
#This procedure CountPropertiesForSaleOrRent retrieves the count of properties available for sale and for rent separately by querying the property table based on the 'for_sale' and 'for_rent' types. Then, it returns the counts of properties for sale and for rent as a result set.


