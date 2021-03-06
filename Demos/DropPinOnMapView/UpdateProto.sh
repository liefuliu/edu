rm ./ProtoGen/*.h
rm ./ProtoGen/*.m

PROTO_FILES=./Proto/*.proto
for f in $PROTO_FILES
do
  ./protoc --plugin=/usr/local/bin/protoc-gen-objc $f --objc_out=./ProtoGen --proto_path=./Proto/
  echo $f compiled
done