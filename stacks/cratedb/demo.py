from crate import client

# CrateDB connection settings
CRATE_HOST = "http://192.168.1.10:4200"  # Change this to your CrateDB instance IP if not running locally

# Connect to CrateDB
connection = client.connect(CRATE_HOST)
cursor = connection.cursor()

# SQL to create a table
create_table_sql = """
CREATE TABLE IF NOT EXISTS my_table (
    id INTEGER PRIMARY KEY,
    name STRING,
    age INTEGER,
    city STRING
)
"""

# Execute the create table statement
cursor.execute(create_table_sql)
print("Table created successfully.")

# SQL to insert data
insert_data_sql = """
INSERT INTO my_table (id, name, age, city) VALUES (?, ?, ?, ?)
"""

# Sample data to insert
sample_data = [
    (4, 'Alice', 30, 'New York'),
    (5, 'Bob', 25, 'Los Angeles'),
    (6, 'Charlie', 35, 'Chicago')
]

# Insert each row of sample data
for row in sample_data:
    cursor.execute(insert_data_sql, row)

print("Data inserted successfully.")

# Close the connection
cursor.close()
connection.close()
