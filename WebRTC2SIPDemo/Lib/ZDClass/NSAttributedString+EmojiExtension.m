//
// Created by zorro on 15/3/7.
// Copyright (c) 2015 tutuge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSAttributedString+EmojiExtension.h"
#import "EmojiTextAttachment.h"

@implementation NSAttributedString (EmojiExtension)

- (NSString *)getPlainStringWithBlock:(void (^)(BOOL isContainEmoji))block
{
    NSMutableString *plainString = [NSMutableString stringWithString:self.string];
    __block NSUInteger base = 0;
    __block BOOL isContainEmoji_b = NO;
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length)
                     options:0
                  usingBlock:^(id value, NSRange range, BOOL *stop) {
                      if (value && [value isKindOfClass:[EmojiTextAttachment class]])
                      {
                          if (!isContainEmoji_b)
                          {
                              isContainEmoji_b = YES;
                              if (block)
                              {
                                  block(isContainEmoji_b);
                              }
                          }
                          [plainString replaceCharactersInRange:NSMakeRange(range.location + base, range.length)
                                                     withString:((EmojiTextAttachment *) value).emojiTag];
                          base += ((EmojiTextAttachment *) value).emojiTag.length - 1;
                      }
                  }];
    return plainString;
}

@end
