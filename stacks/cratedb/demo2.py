import uuid
from crate import client

# Connect to CrateDB
connection = client.connect("http://192.168.1.10:4200", error_trace=True)
cursor = connection.cursor()

# Create the table with _id as the primary key
cursor.execute("CREATE TABLE IF NOT EXISTS my_table2 (id STRING PRIMARY KEY)")

# Generate a UUID for the primary key
data = {
    "id": str(uuid.uuid4()),  # Unique identifier
    "name": "Alice",
    "age": 30,
    "location": "Wonderland",
    "hobbies": ["reading", "adventuring"]
}

# Insert the data
columns = ', '.join(data.keys())
placeholders = ', '.join(['?'] * len(data))
query = f"INSERT INTO my_table ({columns}) VALUES ({placeholders})"
cursor.execute(query, list(data.values()))

print("Record inserted with UUID primary key.")
connection.close()
