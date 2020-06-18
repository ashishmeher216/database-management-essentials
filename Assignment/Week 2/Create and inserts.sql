CREATE TABLE Customer (
  custno   VARCHAR(8)     NOT NULL,
  custname VARCHAR(30) NOT NULL,
  address  VARCHAR(50) NOT NULL,
  Internal CHAR(1)     NOT NULL,
  contact  VARCHAR(50) NOT NULL,
  phone    VARCHAR(30) NOT NULL,
  city     VARCHAR(30) NOT NULL,
  state    VARCHAR(2)  NOT NULL,
  zip      VARCHAR(10) NOT NULL,
  
  CONSTRAINT CustomerPK PRIMARY KEY (custno)
);

CREATE TABLE Employee (
  empno      VARCHAR(8)     NOT NULL,
  empname    VARCHAR(30)  NOT NULL,
  department VARCHAR(30)  NOT NULL,
  email      VARCHAR(255) NOT NULL,
  phone      VARCHAR(30)  NOT NULL,
  CONSTRAINT EmployeePK PRIMARY KEY (empno)
);
  
CREATE TABLE Facility (
  facno   VARCHAR(8)    NOT NULL,
  facname VARCHAR(30) NOT NULL,
  CONSTRAINT FacilityPK PRIMARY KEY (facno)
);



CREATE TABLE Location (
  locno   VARCHAR(8)     NOT NULL,
  facno   VARCHAR(8)     NOT NULL,
  locname VARCHAR(30) NOT NULL,
  CONSTRAINT LocationPK PRIMARY KEY (locno),
  CONSTRAINT FacilityFK FOREIGN KEY (facno) REFERENCES Facility (facno)
);




CREATE TABLE ResourceTbl (
  resno   VARCHAR(8)       NOT NULL,
  resname VARCHAR(30)   NOT NULL,
  rate    DECIMAL(8, 2) NOT NULL,
  CONSTRAINT ResourceTbl_PK PRIMARY KEY (resno),
  CHECK (rate>0)
);

CREATE TABLE EventRequest (
  eventno     VARCHAR(8)       NOT NULL,
  dateheld    DATE          NOT NULL,
  datereq     DATE          NOT NULL,
  facno       VARCHAR(8)       NOT NULL,
  custno      VARCHAR(8)       NOT NULL,
  dateauth    DATE,
  status      CHAR(20)      NOT NULL,
  estcost     DECIMAL(8, 2) NOT NULL,
  estaudience INTEGER       NOT NULL,
  budno       CHAR(30),
  CONSTRAINT EventRequest_PK PRIMARY KEY (eventno),
  CONSTRAINT FK_Facility FOREIGN KEY (facno) REFERENCES Facility (facno),
  CONSTRAINT FK_Customer FOREIGN KEY (custno) REFERENCES Customer (custno),
  CHECK (status IN('Pending','Denied','Approved') AND estaudience>0)
);

CREATE TABLE EventPlan (
  planno   VARCHAR(8)  NOT NULL,
  eventno  VARCHAR(8)  NOT NULL,
  workdate DATE     NOT NULL,
  notes    TEXT,
  activity CHAR(10) NOT NULL,
  empno    VARCHAR(8),
  
  CONSTRAINT EventPlan_PK PRIMARY KEY (planno),
  CONSTRAINT FK_EventRequest FOREIGN KEY (eventno) REFERENCES EventRequest (eventno),
  CONSTRAINT FK_Employee FOREIGN KEY (empno) REFERENCES Employee (empno)
);

CREATE TABLE EventPlanLine (
  planno    VARCHAR(8)   NOT NULL,
  lineNo    VARCHAR(8)   NOT NULL,
  TimeStart DATETIME NOT NULL,
  TimeEnd   DATETIME NOT NULL,
  NumberFld INTEGER   NOT NULL,
  locno     VARCHAR(8)   NOT NULL,
  resno     VARCHAR(8)   NOT NULL,
  CONSTRAINT EventPlanLine_PK PRIMARY KEY (planno, lineNo),
  CONSTRAINT FK_EventPlan FOREIGN KEY (planno) REFERENCES EventPlan (planno),
  CONSTRAINT FK_Location FOREIGN KEY (locno) REFERENCES Location (locno),
  CONSTRAINT FK_ResourceTbl FOREIGN KEY (resno) REFERENCES ResourceTbl (resno),
  CHECK (TimeEnd>TimeStart)
);


# Inserts statements for tables

#Customer
INSERT INTO Customer (custno, custname, address, Internal, city, zip, state, contact, phone) VALUES
  ('C100', 'Football', 'Box 352200', TRUE, 'Boulder', '80309', 'CO', 'Mary Manager', '6857100');

INSERT INTO Customer (custno, custname, address, Internal, city, zip, state, contact, phone) VALUES
  ('C101', 'Men\'s Basketball', 'Box 352400', TRUE, 'Boulder', '80309', 'CO', 'Sally Supervisor', '5431700');

INSERT INTO Customer (custno, custname, address, Internal, city, zip, state, contact, phone) VALUES
  ('C103', 'Baseball', 'Box 352020', TRUE, 'Boulder', '80309', 'CO', 'Bill Baseball', '5431234');

INSERT INTO Customer (custno, custname, address, Internal, city, zip, state, contact, phone) VALUES
  ('C104', 'Women\'s Softball', 'Box 351200', TRUE, 'Boulder', '80309', 'CO', 'Sue Softball', '5434321');

INSERT INTO Customer (custno, custname, address, Internal, city, zip, state, contact, phone) VALUES
  ('C105', 'High School Football', '123 AnyStreet', FALSE, 'Louisville', '80027', 'CO', 'Coach Bob', '4441234');

#Employee
INSERT INTO Employee (empno, empname, department, email, phone) VALUES ('E100','Chuck Coordinator','Administration','chuck@colorado.edu','3-1111');

INSERT INTO Employee (empno, empname, department, email, phone) VALUES ('E101','Mary Manager','Football','mary@colorado.edu','5-1111');

INSERT INTO Employee (empno, empname, department, email, phone) VALUES ('E102','Sally Supervisor','Planning','sally@colorado.edu','3-2222');

INSERT INTO Employee (empno, empname, department, email, phone) VALUES ('E103','Alan Administrator','Administration','alan@colorado.edu','3-3333');

#Facility
INSERT INTO Facility (facno, facname) VALUES ('F100', 'Football stadium');
INSERT INTO Facility (facno, facname) VALUES ('F101', 'Basketball arena');
INSERT INTO Facility (facno, facname) VALUES ('F102', 'Baseball field');
INSERT INTO Facility (facno, facname) VALUES ('F103', 'Recreation room');

#Location
INSERT INTO Location (locno, facno, locname) VALUES ('L100', 'F100', 'Locker room');
INSERT INTO Location (locno, facno, locname) VALUES ('L101', 'F100', 'Plaza');
INSERT INTO Location (locno, facno, locname) VALUES ('L102', 'F100', 'Vehicle gate');
INSERT INTO Location (locno, facno, locname) VALUES ('L103', 'F101', 'Locker room');
INSERT INTO Location (locno, facno, locname) VALUES ('L104', 'F100', 'Ticket Booth');
INSERT INTO Location (locno, facno, locname) VALUES ('L105', 'F101', 'Gate');
INSERT INTO Location (locno, facno, locname) VALUES ('L106', 'F100', 'Pedestrian gate');

#ResourceTbl
INSERT INTO ResourceTbl (resno, resname, rate) VALUES ('R100', 'attendant', '10.00');
INSERT INTO ResourceTbl (resno, resname, rate) VALUES ('R101', 'police', '15.00');
INSERT INTO ResourceTbl (resno, resname, rate) VALUES ('R102', 'usher', '10.00');
INSERT INTO ResourceTbl (resno, resname, rate) VALUES ('R103', 'nurse', '20.00');
INSERT INTO ResourceTbl (resno, resname, rate) VALUES ('R104', 'janitor', '15.00');
INSERT INTO ResourceTbl (resno, resname, rate) VALUES ('R105', 'food service', '10.00');

#EventRequest
INSERT INTO EventRequest (eventno, custno, facno, dateheld, datereq, dateauth, status, estcost, estaudience, budno)
VALUES ('E100', 'C100', 'F100', '2018-10-25', '2018-06-06', '2018-06-08', 'Approved', '5000.00', '80000', 'B1000');

INSERT INTO EventRequest (eventno, custno, facno, dateheld, datereq, dateauth, status, estcost, estaudience, budno)
VALUES ('E101', 'C100', 'F100', '2018-10-26', '2018-07-28', NULL, 'Pending', '5000.00', '80000', 'B1000');

INSERT INTO EventRequest (eventno, custno, facno, dateheld, datereq, dateauth, status, estcost, estaudience, budno)
VALUES ('E102', 'C100', 'F100', '2018-09-14', '2018-07-28', '2018-07-31', 'Approved', '5000.00', '80000', 'B1000');

INSERT INTO EventRequest (eventno, custno, facno, dateheld, datereq, dateauth, status, estcost, estaudience, budno)
VALUES ('E103', 'C100', 'F100', '2018-09-21', '2018-07-28', '2018-08-01', 'Approved', '5000.00', '80000', 'B1000');

INSERT INTO EventRequest (eventno, custno, facno, dateheld, datereq, dateauth, status, estcost, estaudience, budno)
VALUES ('E104', 'C101', 'F101', '2018-12-03', '2018-07-28', '2018-07-31', 'Approved', '2000.00', '12000', 'B1000');

INSERT INTO EventRequest (eventno, custno, facno, dateheld, datereq, dateauth, status, estcost, estaudience, budno)
VALUES ('E105', 'C101', 'F101', '2018-12-05', '2018-07-28', '2018-08-01', 'Approved', '2000.00', '10000', 'B1000');

INSERT INTO EventRequest (eventno, custno, facno, dateheld, datereq, dateauth, status, estcost, estaudience, budno)
VALUES ('E106', 'C101', 'F101', '2018-12-12', '2018-07-28', '2018-07-31', 'Approved', '2000.00', '10000', 'B1000');

INSERT INTO EventRequest (eventno, custno, facno, dateheld, datereq, dateauth, status, estcost, estaudience, budno)
VALUES ('E107', 'C105', 'F100', '2018-11-23', '2018-07-28', '2018-07-31', 'Denied', '10000.00', '5000', NULL);

#EventPlan
INSERT INTO EventPlan (planno, eventno, empno, workdate, notes, activity)
VALUES ('P100', 'E100', 'E102', '2018-10-25', 'Standard operation', 'Operation');

INSERT INTO EventPlan (planno, eventno, empno, workdate, notes, activity)
VALUES ('P101', 'E104', 'E100', '2018-12-03', 'Watch for gate crashers', 'Operation');

INSERT INTO EventPlan (planno, eventno, empno, workdate, notes, activity)
VALUES ('P102', 'E105', 'E102', '2018-12-05', 'Standard operation', 'Operation');

INSERT INTO EventPlan (planno, eventno, empno, workdate, notes, activity)
VALUES ('P103', 'E106', NULL, '2018-12-12', 'Watch for seat switching', 'Operation');

INSERT INTO EventPlan (planno, eventno, empno, workdate, notes, activity)
VALUES ('P104', 'E101', 'E101', '2018-10-26', 'Standard cleanup', 'Cleanup');

INSERT INTO EventPlan (planno, eventno, empno, workdate, notes, activity)
VALUES ('P105', 'E100', 'E101', '2018-10-25', 'Light cleanup', 'Cleanup');

INSERT INTO EventPlan (planno, eventno, empno, workdate, notes, activity)
VALUES ('P199', 'E102', 'E101', '2018-12-10', 'Standard operation', 'Operation');
#
INSERT INTO EventPlan (planno, eventno, empno, workdate, notes, activity)
VALUES ('P299', 'E101', 'E101', '2018-10-26', '', 'Operation');

INSERT INTO EventPlan (planno, eventno, empno, workdate, notes, activity)
VALUES ('P349', 'E106', 'E101', '2018-12-12', '', 'Cleanup');

INSERT INTO EventPlan (planno, eventno, empno, workdate, notes, activity)
VALUES ('P85', 'E100', 'E102', '2018-10-25', 'Standard operation', 'Setup');

INSERT INTO EventPlan (planno, eventno, empno, workdate, notes, activity)
VALUES ('P95', 'E101', 'E102', '2018-10-26', 'Extra security', 'Setup');

# #EventPlanLine
INSERT INTO EventPlanLine(planno, lineNo, locno, resno, TimeStart, TimeEnd, numberFLD) VALUES ('P100', '1','L100','R100','2018-10-25 8:00','2018-10-25 17:00','2');

INSERT INTO EventPlanLine(planno, lineNo, locno, resno, TimeStart, TimeEnd, numberFLD) VALUES ('P100', '2','L101','R101','2018-10-25 12:00','2018-10-25 17:00','2');

INSERT INTO EventPlanLine(planno, lineNo, locno, resno, TimeStart, TimeEnd, numberFLD) VALUES ('P100', '3','L102','R102','2018-10-25 7:00','2018-10-25 16:30','1');

INSERT INTO EventPlanLine(planno, lineNo, locno, resno, TimeStart, TimeEnd, numberFLD) VALUES ('P100', '4','L100','R102','2018-10-25 18:00','2018-12-12 22:00','2');

INSERT INTO EventPlanLine(planno, lineNo, locno, resno, TimeStart, TimeEnd, numberFLD) VALUES ('P101', '1','L103','R100','2018-12-03 18:00','2018-12-03 20:00','2');

INSERT INTO EventPlanLine(planno, lineNo, locno, resno, TimeStart, TimeEnd, numberFLD) VALUES ('P101', '2','L105','R100','2018-12-03 18:30','2018-12-03 19:00','2');

INSERT INTO EventPlanLine(planno, lineNo, locno, resno, TimeStart, TimeEnd, numberFLD) VALUES ('P101', '3','L103','R103','2018-12-03 19:00','2018-12-03 20:00','4');

INSERT INTO EventPlanLine(planno, lineNo, locno, resno, TimeStart, TimeEnd, numberFLD) VALUES ('P102', '1','L103','R100','2018-12-05 18:00','2018-12-05 19:00','2');

INSERT INTO EventPlanLine(planno, lineNo, locno, resno, TimeStart, TimeEnd, numberFLD) VALUES ('P102', '2','L105','R100','2018-12-05 18:00','2018-12-05 21:00','2');

INSERT INTO EventPlanLine(planno, lineNo, locno, resno, TimeStart, TimeEnd, numberFLD) VALUES ('P102', '3','L103','R103','2018-12-05 19:00','2018-12-05 22:00','4');

INSERT INTO EventPlanLine(planno, lineNo, locno, resno, TimeStart, TimeEnd, numberFLD) VALUES ('P103', '1','L103','R100','2018-12-12 18:00','2018-12-12 21:00','2');

INSERT INTO EventPlanLine(planno, lineNo, locno, resno, TimeStart, TimeEnd, numberFLD) VALUES ('P103', '2','L105','R100','2018-12-12 18:00','2018-12-12 21:00','4');

INSERT INTO EventPlanLine(planno, lineNo, locno, resno, TimeStart, TimeEnd, numberFLD) VALUES ('P103', '3','L103','R103','2018-12-12 19:00','2018-12-12 22:00','2');

INSERT INTO EventPlanLine(planno, lineNo, locno, resno, TimeStart, TimeEnd, numberFLD) VALUES ('P104', '1','L101','R104','2018-10-26 18:00','2018-10-26 22:00','4');

INSERT INTO EventPlanLine(planno, lineNo, locno, resno, TimeStart, TimeEnd, numberFLD) VALUES ('P104', '2','L100','R104','2018-10-26 18:00','2018-10-26 22:00','4');

INSERT INTO EventPlanLine(planno, lineNo, locno, resno, TimeStart, TimeEnd, numberFLD) VALUES ('P105', '1','L101','R104','2018-10-25 18:00','2018-10-25 22:00','4');

INSERT INTO EventPlanLine(planno, lineNo, locno, resno, TimeStart, TimeEnd, numberFLD) VALUES ('P105', '2','L100','R104','2018-10-25 18:00','2018-10-25 22:00','4');

INSERT INTO EventPlanLine(planno, lineNo, locno, resno, TimeStart, TimeEnd, numberFLD) VALUES ('P199', '1','L100','R100','2018-12-10 8:00','2018-12-10 12:00','1');

INSERT INTO EventPlanLine(planno, lineNo, locno, resno, TimeStart, TimeEnd, numberFLD) VALUES ('P349', '1','L103','R100','2018-12-12 12:00','2018-12-12 15:30','1');

INSERT INTO EventPlanLine(planno, lineNo, locno, resno, TimeStart, TimeEnd, numberFLD) VALUES ('P85', '1','L100','R100','2018-10-25 9:00','2018-10-25 17:00','5');

INSERT INTO EventPlanLine(planno, lineNo, locno, resno, TimeStart, TimeEnd, numberFLD) VALUES ('P85', '2','L102','R101','2018-10-25 8:00','2018-10-25 17:00','2');

INSERT INTO EventPlanLine(planno, lineNo, locno, resno, TimeStart, TimeEnd, numberFLD) VALUES ('P85', '3','L104','R100','2018-10-25 10:00','2018-10-25 17:00','3');

INSERT INTO EventPlanLine(planno, lineNo, locno, resno, TimeStart, TimeEnd, numberFLD) VALUES ('P95', '1','L100','R100','2018-10-26 8:00','2018-10-26 17:00','4');

INSERT INTO EventPlanLine(planno, lineNo, locno, resno, TimeStart, TimeEnd, numberFLD) VALUES ('P95', '2','L102','R101','2018-10-26 9:00','2018-10-26 17:00','4');

INSERT INTO EventPlanLine(planno, lineNo, locno, resno, TimeStart, TimeEnd, numberFLD) VALUES ('P95', '3','L106','R100','2018-10-26 10:00','2018-10-26 15:00','4');

INSERT INTO EventPlanLine(planno, lineNo, locno, resno, TimeStart, TimeEnd, numberFLD) VALUES ('P95', '4','L100','R103','2018-10-26 13:00','2018-10-26 17:00','2');

INSERT INTO EventPlanLine(planno, lineNo, locno, resno, TimeStart, TimeEnd, numberFLD) VALUES ('P95', '5','L101','R104','2018-10-26 13:00','2018-10-26 17:00','2');


