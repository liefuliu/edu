// Generated by the protocol buffer compiler.  DO NOT EDIT!

#import <ProtocolBuffers/ProtocolBuffers.h>

// @@protoc_insertion_point(imports)

@class SRXDataImage;
@class SRXDataImageBuilder;
@class SRXDataImageRef;
@class SRXDataImageRefBuilder;
@class SRXDataImageServerTypeEnum;
@class SRXDataImageServerTypeEnumBuilder;


typedef NS_ENUM(SInt32, SRXDataImageServerTypeEnumImageServerType) {
  SRXDataImageServerTypeEnumImageServerTypeUnknown = 0,
  SRXDataImageServerTypeEnumImageServerTypeParse = 1,
};

BOOL SRXDataImageServerTypeEnumImageServerTypeIsValidValue(SRXDataImageServerTypeEnumImageServerType value);
NSString *NSStringFromSRXDataImageServerTypeEnumImageServerType(SRXDataImageServerTypeEnumImageServerType value);


@interface SrxdataImageRoot : NSObject {
}
+ (PBExtensionRegistry*) extensionRegistry;
+ (void) registerAllExtensions:(PBMutableExtensionRegistry*) registry;
@end

#define SRXDataImage_data @"data"
@interface SRXDataImage : PBGeneratedMessage<GeneratedMessageProtocol> {
@private
  BOOL hasData_:1;
  NSData* data;
}
- (BOOL) hasData;
@property (readonly, strong) NSData* data;

+ (instancetype) defaultInstance;
- (instancetype) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (SRXDataImageBuilder*) builder;
+ (SRXDataImageBuilder*) builder;
+ (SRXDataImageBuilder*) builderWithPrototype:(SRXDataImage*) prototype;
- (SRXDataImageBuilder*) toBuilder;

+ (SRXDataImage*) parseFromData:(NSData*) data;
+ (SRXDataImage*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (SRXDataImage*) parseFromInputStream:(NSInputStream*) input;
+ (SRXDataImage*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (SRXDataImage*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (SRXDataImage*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface SRXDataImageBuilder : PBGeneratedMessageBuilder {
@private
  SRXDataImage* resultSrxdataImage;
}

- (SRXDataImage*) defaultInstance;

- (SRXDataImageBuilder*) clear;
- (SRXDataImageBuilder*) clone;

- (SRXDataImage*) build;
- (SRXDataImage*) buildPartial;

- (SRXDataImageBuilder*) mergeFrom:(SRXDataImage*) other;
- (SRXDataImageBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (SRXDataImageBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasData;
- (NSData*) data;
- (SRXDataImageBuilder*) setData:(NSData*) value;
- (SRXDataImageBuilder*) clearData;
@end

@interface SRXDataImageServerTypeEnum : PBGeneratedMessage<GeneratedMessageProtocol> {
@private
}

+ (instancetype) defaultInstance;
- (instancetype) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (SRXDataImageServerTypeEnumBuilder*) builder;
+ (SRXDataImageServerTypeEnumBuilder*) builder;
+ (SRXDataImageServerTypeEnumBuilder*) builderWithPrototype:(SRXDataImageServerTypeEnum*) prototype;
- (SRXDataImageServerTypeEnumBuilder*) toBuilder;

+ (SRXDataImageServerTypeEnum*) parseFromData:(NSData*) data;
+ (SRXDataImageServerTypeEnum*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (SRXDataImageServerTypeEnum*) parseFromInputStream:(NSInputStream*) input;
+ (SRXDataImageServerTypeEnum*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (SRXDataImageServerTypeEnum*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (SRXDataImageServerTypeEnum*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface SRXDataImageServerTypeEnumBuilder : PBGeneratedMessageBuilder {
@private
  SRXDataImageServerTypeEnum* resultSrxdataImageServerTypeEnum;
}

- (SRXDataImageServerTypeEnum*) defaultInstance;

- (SRXDataImageServerTypeEnumBuilder*) clear;
- (SRXDataImageServerTypeEnumBuilder*) clone;

- (SRXDataImageServerTypeEnum*) build;
- (SRXDataImageServerTypeEnum*) buildPartial;

- (SRXDataImageServerTypeEnumBuilder*) mergeFrom:(SRXDataImageServerTypeEnum*) other;
- (SRXDataImageServerTypeEnumBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (SRXDataImageServerTypeEnumBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

#define SRXDataImageRef_server_type @"serverType"
#define SRXDataImageRef_image_key @"imageKey"
@interface SRXDataImageRef : PBGeneratedMessage<GeneratedMessageProtocol> {
@private
  BOOL hasImageKey_:1;
  BOOL hasServerType_:1;
  NSString* imageKey;
  SRXDataImageServerTypeEnumImageServerType serverType;
}
- (BOOL) hasServerType;
- (BOOL) hasImageKey;
@property (readonly) SRXDataImageServerTypeEnumImageServerType serverType;
@property (readonly, strong) NSString* imageKey;

+ (instancetype) defaultInstance;
- (instancetype) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (SRXDataImageRefBuilder*) builder;
+ (SRXDataImageRefBuilder*) builder;
+ (SRXDataImageRefBuilder*) builderWithPrototype:(SRXDataImageRef*) prototype;
- (SRXDataImageRefBuilder*) toBuilder;

+ (SRXDataImageRef*) parseFromData:(NSData*) data;
+ (SRXDataImageRef*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (SRXDataImageRef*) parseFromInputStream:(NSInputStream*) input;
+ (SRXDataImageRef*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (SRXDataImageRef*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (SRXDataImageRef*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface SRXDataImageRefBuilder : PBGeneratedMessageBuilder {
@private
  SRXDataImageRef* resultSrxdataImageRef;
}

- (SRXDataImageRef*) defaultInstance;

- (SRXDataImageRefBuilder*) clear;
- (SRXDataImageRefBuilder*) clone;

- (SRXDataImageRef*) build;
- (SRXDataImageRef*) buildPartial;

- (SRXDataImageRefBuilder*) mergeFrom:(SRXDataImageRef*) other;
- (SRXDataImageRefBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (SRXDataImageRefBuilder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasServerType;
- (SRXDataImageServerTypeEnumImageServerType) serverType;
- (SRXDataImageRefBuilder*) setServerType:(SRXDataImageServerTypeEnumImageServerType) value;
- (SRXDataImageRefBuilder*) clearServerType;

- (BOOL) hasImageKey;
- (NSString*) imageKey;
- (SRXDataImageRefBuilder*) setImageKey:(NSString*) value;
- (SRXDataImageRefBuilder*) clearImageKey;
@end


// @@protoc_insertion_point(global_scope)