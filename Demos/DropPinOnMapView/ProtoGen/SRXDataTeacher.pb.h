// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import <ProtocolBuffers/ProtocolBuffers.h>

#import "SRXDataImage.pb.h"
#import "SRXDataPersonName.pb.h"
#import "SRXDataClass.pb.h"
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
@class SRXDataTeacher;
@class SRXDataTeacherBuilder;



@interface SrxdataTeacherRoot : NSObject {
}
+ (PBExtensionRegistry*) extensionRegistry;
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry;
@end

#define SRXDataTeacher_name @"name"
#define SRXDataTeacher_resume @"resume"
#define SRXDataTeacher_image_ref @"imageRef"
#define SRXDataTeacher_course_to_teach @"courseToTeach"
@interface SRXDataTeacher : PBGeneratedMessage<GeneratedMessageProtocol> {
@private
  BOOL hasResume_:1;
  BOOL hasName_:1;
  NSString* resume;
  SRXDataPersonName* name;
  NSMutableArray * imageRefArray;
  PBAppendableArray * courseToTeachArray;
}
- (BOOL) hasName;
- (BOOL) hasResume;
@property (readonly, strong) SRXDataPersonName* name;
@property (readonly, strong) NSString* resume;
@property (readonly, strong) NSArray * imageRef;
@property (readonly, strong) PBArray * courseToTeach;
- (SRXDataImageRef*)imageRefAtIndex:(NSUInteger)index;
- (SRXDataClassTypeEnumSRXDataClassType)courseToTeachAtIndex:(NSUInteger)index;

+ (instancetype) defaultInstance;
- (instancetype) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (SRXDataTeacherBuilder*) builder;
+ (SRXDataTeacherBuilder*) builder;
+ (SRXDataTeacherBuilder*) builderWithPrototype:(SRXDataTeacher*) prototype;
- (SRXDataTeacherBuilder*) toBuilder;

+ (SRXDataTeacher*) parseFromData:(NSData*) data;
+ (SRXDataTeacher*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (SRXDataTeacher*) parseFromInputStream:(NSInputStream*) input;
+ (SRXDataTeacher*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (SRXDataTeacher*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (SRXDataTeacher*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface SRXDataTeacherBuilder : PBGeneratedMessageBuilder {
@private
  SRXDataTeacher* resultSrxdataTeacher;
}

- (SRXDataTeacher*) defaultInstance;

- (SRXDataTeacherBuilder*) clear;
- (SRXDataTeacherBuilder*) clone;

- (SRXDataTeacher*) build;
- (SRXDataTeacher*) buildPartial;

- (SRXDataTeacherBuilder*) mergeFrom:(SRXDataTeacher*) other;
- (SRXDataTeacherBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (SRXDataTeacherBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasName;
- (SRXDataPersonName*) name;
- (SRXDataTeacherBuilder*) setName:(SRXDataPersonName*) value;
- (SRXDataTeacherBuilder*) setNameBuilder:(SRXDataPersonNameBuilder*) builderForValue;
- (SRXDataTeacherBuilder*) mergeName:(SRXDataPersonName*) value;
- (SRXDataTeacherBuilder*) clearName;

- (BOOL) hasResume;
- (NSString*) resume;
- (SRXDataTeacherBuilder*) setResume:(NSString*) value;
- (SRXDataTeacherBuilder*) clearResume;

- (NSMutableArray *)imageRef;
- (SRXDataImageRef*)imageRefAtIndex:(NSUInteger)index;
- (SRXDataTeacherBuilder *)addImageRef:(SRXDataImageRef*)value;
- (SRXDataTeacherBuilder *)setImageRefArray:(NSArray *)array;
- (SRXDataTeacherBuilder *)clearImageRef;

- (PBAppendableArray *)courseToTeach;
- (SRXDataClassTypeEnumSRXDataClassType)courseToTeachAtIndex:(NSUInteger)index;
- (SRXDataTeacherBuilder *)addCourseToTeach:(SRXDataClassTypeEnumSRXDataClassType)value;
- (SRXDataTeacherBuilder *)setCourseToTeachArray:(NSArray *)array;
- (SRXDataTeacherBuilder *)setCourseToTeachValues:(const SRXDataClassTypeEnumSRXDataClassType *)values count:(NSUInteger)count;
- (SRXDataTeacherBuilder *)clearCourseToTeach;
@end


// @@protoc_insertion_point(global_scope)
