//
// Created by zorro on 15/3/7.
// Copyright (c) 2015 tutuge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (EmojiExtension)
- (NSString *)getPlainStringWithBlock:(void (^)(BOOL isContainEmoji))block;
@end
