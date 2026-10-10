# Data dictionary for Gold Layer
## Over View
  The gold layer is bussiness-level data representation,structured to support analytical and reporting usecases.
it consists dimension tables and fact tables to for specific business metrics 

### 1. gold.dim_customers
**Purpose**: Stores customer details enriched with demographic and geographic data.
**Columns**:

|Coumn Name | Data Type| Description|
|-----------|----------|------------|
|Customer_key|   INT|
|Customer_Id|    INT|
|Customer_Number| NVarchar(50)|
|First_name| NVarchar(50)|
|Last_name| NVarchar(50)|
|Country| NVarchar(50)|
|Material_status| NVarchar(50)|
|Gender| NVarchar(50)|
|Birth_date| NVarchar(50)|
|create_date| NVarchar(50)|


