#!/bin/bash

echo "MongoDB Replica Set'i başlatılıyor..."
sleep 10

mongosh --host mongo1 --eval '
  rs.initiate({
    _id: "rs0",
    members: [
      { _id: 0, host: "mongo1:27017", priority: 2 },
      { _id: 1, host: "mongo2:27017", priority: 1 },
      { _id: 2, host: "mongo3:27017", priority: 1 }
    ]
  })
'

echo "MongoDB Replica Set başarıyla başlatıldı ve yapılandırıldı!"

mongosh --host mongo1 --eval "rs.status()"
