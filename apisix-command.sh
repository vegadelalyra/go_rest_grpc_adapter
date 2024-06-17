## Store the protobuf file hello.proto as a proto object in APISIX with id quickstart-proto
curl -i "http://127.0.0.1:9180/apisix/admin/protos" -H 'X-API-KEY:edd1c9f034335f136f87ad84b625c8f1' -X PUT -d '
{
    "id": "quickstart-proto",
    "content": "syntax = \"proto2\";
    package hello;

    service HelloService {
        rpc SayHello(HelloRequest) returns (HelloResponse);
        rpc LotsOfReplies(HelloRequest) returns (stream HelloResponse);
        rpc LotsOfGreetings(stream HelloRequest) returns (HelloResponse);
        rpc BidiHello(stream HelloRequest) returns (stream HelloResponse);
    }

    message HelloRequest {
        optional string greeting = 1;
    }

    message HelloResponse {
        required string reply = 1;
    }"
}'

## Enable grpc-transcode Plugin in a new Route object of APISIX
curl -i "http://127.0.0.1:9180/apisix/admin/routes" -X PUT -H 'X-API-KEY:edd1c9f034335f136f87ad84b625c8f1' -d  '
{
    "id": "quickstart-grpc",
    "methods": ["GET"],
    "uri": "/hello",
    "plugins": {
        "grpc-transcode": {
            "proto_id": "quickstart-proto",
            "service": "hello.HelloService",
            "method": "SayHello"
        }
    },
    "upstream": {
        "scheme": "grpc",
        "type": "roundrobin",
        "nodes": {
            "quickstart-grpc-example:9000": 1
        }
    }
}'