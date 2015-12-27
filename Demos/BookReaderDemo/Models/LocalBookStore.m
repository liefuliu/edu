//
//  LocalBookStore.m
//  BookReaderDemo
//
//  Created by Liefu Liu on 12/25/15.
//  Copyright (c) 2015 SanRenXing. All rights reserved.
//

#import "LocalBookStore.h"

@interface LocalBookStore()

@property NSDictionary* bookStore;

@end

@implementation LocalBookStore

- (NSArray*) allBookKeys {
    return [self.bookStore allKeys];
}

- (LocalBook*) getBookWithKey:(NSString*) bookKey {
    return (LocalBook*)[self.bookStore objectForKey:bookKey];
}

+ (id)sharedObject {
    static LocalBookStore *object = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object = [[self alloc] init];
    });
    return object;
}

- (id)init {
    if (self = [super init]) {
        LocalBook* bookStanley = [LocalBookStore createBook:@"stanley"];
        LocalBook* bookTheLetters = [LocalBookStore createBook:@"theletters"];
        LocalBook* bookOliver = [LocalBookStore createBook:@"oliver"];
        
        _bookStore = [[NSDictionary alloc] initWithObjectsAndKeys:
                      
                      bookStanley,
                    @"stanley",
                      bookTheLetters,
                      @"theletters",
                      bookOliver,
                      @"oliver",
                      nil
                      /*,
                     @"letters",
                     [self createBook:@"letters"],
                     @"oliver",
                     [self createBook:@"oliver"]*/
                      ];
    }
    return self;
}

+ (LocalBook*) createBook: (NSString*) bookKey {
    if (bookKey == @"stanley") {
        NSArray* translatedText = @[
                                //@"空白项，显示就是bug。", // 空白项。由于currentPage从1开始技术，所以数组的第0项不会被使用。
                                @"",
                                @"",
                                @"在很久很久以前，这没有屋，人住在山洞中。",
                                @"Stanley也住在山洞中，但他却不愿这样。",
                                @"山洞里很寒冷，Stanley也很寒冷。",
                                @"每当Stanley觉得很寒冷，他只能睡在石头上。",
                                @"每当夕阳西沉的时候，蝙蝠四处飞舞着。",
                                @"怎么样更好的生活，Stanley这样问着人们。",
                                @"“这样的生活很精彩，为什么你却觉得很无奈？” 山顶洞人说。",
                                @"其实山顶洞人每天都艰难的扛着棍棒。",
                                @"Stanley也艰难的扛着棍棒。",
                                @"他乐于播种而期盼万物滋长。",
                                @"他喜欢画画让生命跃然纸上。",
                                @"他对别人友好。",
                                @"他对动物慈祥。",
                                @"山顶洞人不愿Stanley这样，\"你能活得正常一点吗？\", 他们说。",
                                @"Stanley没有回答，他依旧播他的种，依旧画他的话。",
                                @"他依然对别人友好，依然对动物慈祥。",
                                @"他甚至开始使用礼貌用语，比如\"请\"，\"谢谢\", \"今天天气不错，您觉得呢？\"。",
                                @"这让其他的山顶洞人很不爽，\n\"给我出去！\", 他们说。\n\"揍他！\""];
        
        return [[LocalBook alloc] initBook:@"Stanley" author:@"Syn Doff" totalPages:58 filePrefix:@"stanley" translatedText:translatedText];
        
    } else if (bookKey == @"theletters") {
        NSArray* translatedText = @[];
        return [[LocalBook alloc] initBook:@"The Letters" author:@"" totalPages:26
                                filePrefix:@"theletters" translatedText:translatedText];
    } else if (bookKey == @"oliver") {
        NSArray* translatedText = @[];
        return [[LocalBook alloc] initBook:@"Oliver" author:@"Syn Doff" totalPages:60
                                filePrefix:@"oliver" translatedText:translatedText];
    }
    return nil;
}


@end
