CREATE SCHEMA david_jones_eofy_sql_analytics;
USE david_jones_eofy_sql_analytics;

-- Table Implementation --
CREATE TABLE PLATFORM (
    Platform_ID                     Integer                         NOT NULL,
    Platform_Name                   Varchar(100)                    NOT NULL,
    Platform_CommissionRate         Decimal(5,3)                    NOT NULL,
    CONSTRAINT                      PLATFORM_PK                     PRIMARY KEY(Platform_ID)
    );


CREATE TABLE CUSTOMER (
    Customer_ID                     Integer                         NOT NULL,
    Customer_FirstName              Varchar(100)                    NOT NULL,
    Customer_LastName               Varchar(100)                    NOT NULL,
    Customer_PhoneNo                Varchar(20)                     NOT NULL,
    Customer_Address                Varchar(255)                    NOT NULL,
    Customer_Email                  Varchar(100)                    NOT NULL,
    CONSTRAINT                      CUSTOMER_PK                     PRIMARY KEY(Customer_ID)
    );


CREATE TABLE SHIPPING (
    Shipping_ID                     Integer                         NOT NULL,
    Shipping_FirstName              Varchar(100)                    NOT NULL,
    Shipping_LastName               Varchar(100)                    NOT NULL,
    Shipping_Address                Varchar(255)                    NOT NULL,
    Shipping_Email                  Varchar(100)                    NOT NULL,
    Shipping_PhoneNo                Varchar(20)                     NOT NULL,
    CONSTRAINT                      SHIPPING_PK                     PRIMARY KEY(Shipping_ID)
    );


CREATE TABLE PRODUCT (
    Product_SKU                     Integer                         NOT NULL,
    Product_Name                    Varchar(100)                    NOT NULL,
    Product_Category                Varchar(100)                    NOT NULL,
    Product_Price                   Decimal(10,2)                   NOT NULL,
    Product_QuantityInStock         Integer                         NOT NULL,
    CONSTRAINT                      PRODUCT_PK                      PRIMARY KEY(Product_SKU)
    );


CREATE TABLE ADVERTISEMENT (
    Ad_ID                           Integer                         NOT NULL,
    Platform_ID                     Integer                         NOT NULL,
    Ad_Name                         Varchar(100)                    NOT NULL,
    Ad_StartDate                    DateTime                        NOT NULL,
    Ad_EndDate                      DateTime                        NULL,
    CONSTRAINT                      AD_PK                           PRIMARY KEY(Ad_ID),
    CONSTRAINT                      AD_PLATFORM_Relationship        FOREIGN KEY(Platform_ID)
                                        REFERENCES PLATFORM(Platform_ID)
    );


CREATE TABLE SHOP_ORDER (
    Order_ID                        Integer                         NOT NULL,
    Customer_ID                     Integer                         NOT NULL,
    Shipping_ID                     Integer                         NOT NULL,
    Ad_ID                           Integer                         NULL,
    Order_AdClickID					Integer							NULL,
    Order_AdClickTime				DateTime						NULL,
    Order_Date                      DateTime                        NOT NULL,
    Order_CommissionRate            Decimal(5,3)                    NULL,
    CONSTRAINT                      SHOP_ORDER_PK                   PRIMARY KEY(Order_ID),
    CONSTRAINT                      ORDER_CUSTOMER_Relationship     FOREIGN KEY(Customer_ID)
                                        REFERENCES CUSTOMER(Customer_ID),
    CONSTRAINT                      ORDER_SHIPPING_Relationship     FOREIGN KEY(Shipping_ID)
                                        REFERENCES SHIPPING(Shipping_ID),
    CONSTRAINT                      ORDER_AD_Relationship           FOREIGN KEY(Ad_ID)
                                        REFERENCES ADVERTISEMENT(Ad_ID)
    );


CREATE TABLE ORDER_PRODUCT (
    Order_ID                        Integer                         NOT NULL,
    Product_SKU                     Integer                         NOT NULL,
    Product_Quantity                Integer                         NOT NULL,
    Product_PriceAtCheckout         Decimal(10,3)                   NOT NULL,
    CONSTRAINT                      ORDER_PRODUCT_PK                PRIMARY KEY(Order_ID, Product_SKU),
    CONSTRAINT                      ORDER_PRODUCT_ORDER_Relationship
                                                                    FOREIGN KEY(Order_ID)
                                        REFERENCES SHOP_ORDER(Order_ID),
    CONSTRAINT                      ORDER_PRODUCT_PRODUCT_Relationship
                                                                    FOREIGN KEY(Product_SKU)
                                        REFERENCES PRODUCT(Product_SKU)
    );


CREATE TABLE PAYMENT (
    Payment_ID                      Integer                         NOT NULL,
    Customer_ID                     Integer                         NOT NULL,
    Order_ID                        Integer                         NOT NULL,
    Payment_Method                  Varchar(50)                     NOT NULL,
    Payment_Status                  Varchar(50)                     NOT NULL,
    CONSTRAINT                      PAYMENT_PK                      PRIMARY KEY(Payment_ID),
    CONSTRAINT                      PAYMENT_CUSTOMER_Relationship   FOREIGN KEY(Customer_ID)
                                        REFERENCES CUSTOMER(Customer_ID),
    CONSTRAINT                      PAYMENT_ORDER_Relationship      FOREIGN KEY(Order_ID)
                                        REFERENCES SHOP_ORDER(Order_ID)
    );
