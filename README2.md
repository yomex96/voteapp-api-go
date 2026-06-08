The logs show exactly why your Go API crashed: it is trying to connect to a MongoDB cluster (mongo-0.mongo, etc.) that doesn't exist on your Mac. Because it cannot reach the database, the Go app panics, throws a timeout error, and shuts down immediately. [1, 2, 3] 
To test this successfully on your MacBook, you have two choices depending on how the Go application is written:
## Option 1: Provide a Local MongoDB Instance (Recommended) [4, 5] 
You can quickly spin up a local MongoDB container and instruct your Go API to connect to it instead. [6] 

   1. Start a local MongoDB container:
   
   docker run -d --name local-mongo -p 27017:27017 mongo:latest
   
   2. Remove your crashed Go container:
   
   docker rm -f voteapp-api
   
   3. Run your Go API using your Mac's local network (host.docker.internal) to reach MongoDB:
   
   docker run -d -p 8081:8080 \
     --name voteapp-api \
     -e MONGO_CONN_STR="mongodb://host.docker.internal:27017/langdb" \
     -e MONGO_USERNAME="" \
     -e MONGO_PASSWORD="" \
     voteapp-backend
   
   [7, 8] 

## Option 2: Run the App in "No-Database" or Mock Mode (If Supported)
Some test applications have a flag or environment variable to run using memory storage instead of a live database. Check your README.md or main.go source code to see if there is an environment variable like DB_MODE=mock or USE_MEMORY=true. If there is, you can pass it with the -e flag when running the container.
To help get this connected, let me know:

* Does this application come with a docker-compose.yml file in the project folder?
* Would you like me to generate a single Docker Compose file that automatically starts MongoDB, your Go Backend, and your React Frontend all together so they link perfectly?


[1] [https://www.reddit.com](https://www.reddit.com/r/mongodb/comments/zwh02m/mongodb_compass_econnrefused_error_in_mac/)
[2] [https://sumanta9090.medium.com](https://sumanta9090.medium.com/connecting-a-go-application-to-mongodb-9ea19c8484df)
[3] [https://oneuptime.com](https://oneuptime.com/blog/post/2026-02-24-how-to-handle-mongodb-protocol-in-istio/view)
[4] [https://www.mongodb.com](https://www.mongodb.com/community/forums/t/mongoserverselectionerror-connection-monitor-to-13-235-142-61-27017-closed/174035)
[5] [https://www.mongodb.com](https://www.mongodb.com/community/forums/t/mongodb-connection-error-in-compass/260093)
[6] [https://maxwellrules.com](https://maxwellrules.com/data/simplemongo.html)
[7] [https://github.com](https://github.com/docker-library/mongo/issues/652)
[8] [https://community.influxdata.com](https://community.influxdata.com/t/influxdb-data-explorer-add-new-server-fails/57939)


------



docker exec -i mongo-backend mongo -u admin -p password --authenticationDatabase admin <<EOF
use langdb;
db.languages.insert({"name" : "csharp", "codedetail" : { "usecase" : "system, web, server-side", "rank" : 5, "compiled" : false, "homepage" : "https://microsoft.com", "download" : "https://microsoft.com", "votes" : 0}});
db.languages.insert({"name" : "python", "codedetail" : { "usecase" : "system, web, server-side", "rank" : 3, "script" : false, "homepage" : "https://python.org", "download" : "https://python.orgdownloads/", "votes" : 0}});
db.languages.insert({"name" : "javascript", "codedetail" : { "usecase" : "web, client-side", "rank" : 7, "script" : false, "homepage" : "https://wikipedia.org", "download" : "n/a", "votes" : 0}});
db.languages.insert({"name" : "go", "codedetail" : { "usecase" : "system, web, server-side", "rank" : 12, "compiled" : true, "homepage" : "https://golang.org", "download" : "https://golang.org", "votes" : 0}});
db.languages.insert({"name" : "java", "codedetail" : { "usecase" : "system, web, server-side", "rank" : 1, "compiled" : true, "homepage" : "https://java.com", "download" : "https://java.comdownload/", "votes" : 0}});
db.languages.insert({"name" : "nodejs", "codedetail" : { "usecase" : "system, web, server-side", "rank" : 20, "script" : false, "homepage" : "https://nodejs.org", "download" : "https://nodejs.orgdownload/", "votes" : 0}});
EOF

