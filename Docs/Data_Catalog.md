# Data dictionary for Gold Layer
## Over View
  The gold layer is bussiness-level data representation,structured to support analytical and reporting usecases.
it consists dimension tables and fact tables to for specific business metrics 

### 1. gold.dim_customers
**Purpose**: Stores customer details enriched with demographic and geographic data.
**Columns**:

|Coumn Name | Data Type| Description|
|-----------|----------|------------|
|Customer_key|   INT|  Surrogate key uniquely identifying each customer record in the dimension table.|
|Customer_Id|    INT|Unique numerical identifier assigned to each customer.|
|Customer_Number| NVarchar(50)|Alphanumeric identifier representing the customer, used for tracking and referencing|
|First_name| NVARCHAR(50)| The customer's first name, as recorded in the system.|
|Last_name| NVARCHAR(50)|The customer's last name or family name.|
|Country| NVARCHAR(50)|The country of residence for the customer (e.g., 'Australia').|
|Material_status| NVARCHAR(50)| The marital status of the customer (e.g., 'Married', 'Single').|
|Gender| NVARCHAR(50)| The gender of the customer (e.g., 'Male', 'Female', 'n/a').|
|Birth_date| NVARCHAR(50)|The date of birth of the customer, formatted as YYYY-MM-DD (e.g., 1971-10-06).|
|create_date| NVARCHAR(50)| The date and time when the customer record was created in the system|


