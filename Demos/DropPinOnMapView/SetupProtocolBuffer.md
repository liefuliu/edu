1. Run following command line to add the dependencies of Protocol Buffers in cocoapods.

echo -e "platform :ios , 6.0 \nlink_with 'DropPinOnMapView', 'DropPinOnMapViewTests' \npod 'ProtocolBuffers'" > Podfile
pod install

2. Run following command lines

mkdir Proto
mkdir ProtoGen

3. (Proposal only, not working...)

 Add a build rules in DropPinOnMapView targets

Source files with name matching: *.proto
Custom script:

cd ${INPUT_FILE_DIR}
${SRCROOT}/protoc --plugin=/usr/local/bin/protoc-gen-objc --proto_path=${INPUT_FILE_DIR} ${INPUT_FILE_PATH} --objc_out=${SRCROOT}/ProtoGen 

Output Files: (Keep it as empty)

4. Manually added ProtoGen files into DropPinOnMapView project.