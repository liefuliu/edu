rm ./ProtoGen/*.h
rm ./ProtoGen/*.m

PROTO_FILES=./Proto/*.proto
for f in $PROTO_FILES
do
  echo $f compiled
  ./protoc --plugin=/usr/local/bin/protoc-gen-objc $f --objc_out=./ProtoGen --proto_path=./Proto/
done