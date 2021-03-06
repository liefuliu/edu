// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import <ProtocolBuffers/ProtocolBuffers.h>

#import "SRXDataLocation.pb.h"
#import "SRXDataImage.pb.h"
#import "SRXDataTeacher.pb.h"
// @@protoc_insertion_point(imports)

@class SRXDataClass;
@class SRXDataClassBuilder;
@class SRXDataClassInfo;
@class SRXDataClassInfoBuilder;
@class SRXDataClassTime;
@class SRXDataClassTimeBuilder;
@class SRXDataClassTypeEnum;
@class SRXDataClassTypeEnumBuilder;
@class SRXDataImage;
@class SRXDataImageBuilder;
@class SRXDataImageRef;
@class SRXDataImageRefBuilder;
@class SRXDataImageServerTypeEnum;
@class SRXDataImageServerTypeEnumBuilder;
@class SRXDataLocation;
@class SRXDataLocationBuilder;
@class SRXDataPersonName;
@class SRXDataPersonNameBuilder;
@class SRXDataSchool;
@class SRXDataSchoolBuilder;
@class SRXDataSchoolInfo;
@class SRXDataSchoolInfoBuilder;
@class SRXDataTeacher;
@class SRXDataTeacherBuilder;



@interface SrxdataSchoolRoot : NSObject {
}
+ (PBExtensionRegistry*) extensionRegistry;
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry;
@end

#define SRXDataSchoolInfo_location @"location"
#define SRXDataSchoolInfo_name @"name"
#define SRXDataSchoolInfo_summary @"summary"
#define SRXDataSchoolInfo_image_ref @"imageRef"
#define SRXDataSchoolInfo_teacher @"teacher"
@interface SRXDataSchoolInfo : PBGeneratedMessage<GeneratedMessageProtocol> {
@private
  BOOL hasName_:1;
  BOOL hasSummary_:1;
  BOOL hasLocation_:1;
  NSString* name;
  NSString* summary;
  SRXDataLocation* location;
  NSMutableArray * imageRefArray;
  NSMutableArray * teacherArray;
}
- (BOOL) hasLocation;
- (BOOL) hasName;
- (BOOL) hasSummary;
@property (readonly, strong) SRXDataLocation* location;
@property (readonly, strong) NSString* name;
@property (readonly, strong) NSString* summary;
@property (readonly, strong) NSArray * imageRef;
@property (readonly, strong) NSArray * teacher;
- (SRXDataImageRef*)imageRefAtIndex:(NSUInteger)index;
- (SRXDataTeacher*)teacherAtIndex:(NSUInteger)index;

+ (instancetype) defaultInstance;
- (instancetype) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (SRXDataSchoolInfoBuilder*) builder;
+ (SRXDataSchoolInfoBuilder*) builder;
+ (SRXDataSchoolInfoBuilder*) builderWithPrototype:(SRXDataSchoolInfo*) prototype;
- (SRXDataSchoolInfoBuilder*) toBuilder;

+ (SRXDataSchoolInfo*) parseFromData:(NSData*) data;
+ (SRXDataSchoolInfo*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (SRXDataSchoolInfo*) parseFromInputStream:(NSInputStream*) input;
+ (SRXDataSchoolInfo*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (SRXDataSchoolInfo*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (SRXDataSchoolInfo*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface SRXDataSchoolInfoBuilder : PBGeneratedMessageBuilder {
@private
  SRXDataSchoolInfo* resultSrxdataSchoolInfo;
}

- (SRXDataSchoolInfo*) defaultInstance;

- (SRXDataSchoolInfoBuilder*) clear;
- (SRXDataSchoolInfoBuilder*) clone;

- (SRXDataSchoolInfo*) build;
- (SRXDataSchoolInfo*) buildPartial;

- (SRXDataSchoolInfoBuilder*) mergeFrom:(SRXDataSchoolInfo*) other;
- (SRXDataSchoolInfoBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (SRXDataSchoolInfoBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasLocation;
- (SRXDataLocation*) location;
- (SRXDataSchoolInfoBuilder*) setLocation:(SRXDataLocation*) value;
- (SRXDataSchoolInfoBuilder*) setLocationBuilder:(SRXDataLocationBuilder*) builderForValue;
- (SRXDataSchoolInfoBuilder*) mergeLocation:(SRXDataLocation*) value;
- (SRXDataSchoolInfoBuilder*) clearLocation;

- (BOOL) hasName;
- (NSString*) name;
- (SRXDataSchoolInfoBuilder*) setName:(NSString*) value;
- (SRXDataSchoolInfoBuilder*) clearName;

- (BOOL) hasSummary;
- (NSString*) summary;
- (SRXDataSchoolInfoBuilder*) setSummary:(NSString*) value;
- (SRXDataSchoolInfoBuilder*) clearSummary;

- (NSMutableArray *)imageRef;
- (SRXDataImageRef*)imageRefAtIndex:(NSUInteger)index;
- (SRXDataSchoolInfoBuilder *)addImageRef:(SRXDataImageRef*)value;
- (SRXDataSchoolInfoBuilder *)setImageRefArray:(NSArray *)array;
- (SRXDataSchoolInfoBuilder *)clearImageRef;

- (NSMutableArray *)teacher;
- (SRXDataTeacher*)teacherAtIndex:(NSUInteger)index;
- (SRXDataSchoolInfoBuilder *)addTeacher:(SRXDataTeacher*)value;
- (SRXDataSchoolInfoBuilder *)setTeacherArray:(NSArray *)array;
- (SRXDataSchoolInfoBuilder *)clearTeacher;
@end

#define SRXDataSchool_id @"id"
#define SRXDataSchool_info @"info"
@interface SRXDataSchool : PBGeneratedMessage<GeneratedMessageProtocol> {
@private
  BOOL hasId_:1;
  BOOL hasInfo_:1;
  NSString* id;
  SRXDataSchoolInfo* info;
}
- (BOOL) hasId;
- (BOOL) hasInfo;
@property (readonly, strong) NSString* id;
@property (readonly, strong) SRXDataSchoolInfo* info;

+ (instancetype) defaultInstance;
- (instancetype) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (SRXDataSchoolBuilder*) builder;
+ (SRXDataSchoolBuilder*) builder;
+ (SRXDataSchoolBuilder*) builderWithPrototype:(SRXDataSchool*) prototype;
- (SRXDataSchoolBuilder*) toBuilder;

+ (SRXDataSchool*) parseFromData:(NSData*) data;
+ (SRXDataSchool*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (SRXDataSchool*) parseFromInputStream:(NSInputStream*) input;
+ (SRXDataSchool*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (SRXDataSchool*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (SRXDataSchool*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface SRXDataSchoolBuilder : PBGeneratedMessageBuilder {
@private
  SRXDataSchool* resultSrxdataSchool;
}

- (SRXDataSchool*) defaultInstance;

- (SRXDataSchoolBuilder*) clear;
- (SRXDataSchoolBuilder*) clone;

- (SRXDataSchool*) build;
- (SRXDataSchool*) buildPartial;

- (SRXDataSchoolBuilder*) mergeFrom:(SRXDataSchool*) other;
- (SRXDataSchoolBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (SRXDataSchoolBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasId;
- (NSString*) id;
- (SRXDataSchoolBuilder*) setId:(NSString*) value;
- (SRXDataSchoolBuilder*) clearId;

- (BOOL) hasInfo;
- (SRXDataSchoolInfo*) info;
- (SRXDataSchoolBuilder*) setInfo:(SRXDataSchoolInfo*) value;
- (SRXDataSchoolBuilder*) setInfoBuilder:(SRXDataSchoolInfoBuilder*) builderForValue;
- (SRXDataSchoolBuilder*) mergeInfo:(SRXDataSchoolInfo*) value;
- (SRXDataSchoolBuilder*) clearInfo;
@end


// @@protoc_insertion_point(global_scope)
