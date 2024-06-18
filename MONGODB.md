# MongoDB

## 🐢 Shell
```sh
> mongosh "mongodb+srv://<server>" --username 
[Enter pwd]

# show all databases
>> show dbs

# connect to a db and list collections
>> use DB-NAME
>> show collections

# create collection
>> db.createCollection("COL-NAME")
# create index (ascending)
>> db.COL-NAME.createIndex({"INDEX-NAME": 1})
>> db.COL-NAME.getIndices()

# create indices on collection creation (AZ!)
>> db.runCommand({    customAction: "CreateCollection",    collection: "game_config",    indexes: [
      {          key: {"session_id": 1},
         name: "session_id_1",
         unique: true
      },
   ]
})
```

## 📁 Dump & Restore

### Creating archive
#### Locally
```sh
mongodump --db DB-NAME --archive=./MY-DUMP.dump
```

#### 🐳 Docker
```sh
docker exec CONTAINER /bin/bash -c "mongodump --db DB-NAME --archive > /PATH/IN/CONTAINER/MY-DUMP.dump"
```

### Restoring backup / archive
```sh
mongorestore \
  --archive=./MY-DUMP.dump \
  # restore to cloud or other local DB
  --username=DB-USER \
  --uri=MONGODB-URI
  # rename
  --nsFrom "OLD-DB.OLD-COL" \
  --nsTo "NEW-DB.NEW-COL"
```
