//
//  Card.h
//  CardGame
//
//  Created by Nicole on 5/13/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;

@property (nonatomic, getter = isChoosen) BOOL chosen;
@property (nonatomic, getter = isMatched) BOOL matched;
@property (nonatomic, getter = isSelected) BOOL selected;

- (int)match:(NSArray *)otherCards;
- (NSString *)createTitle:(NSArray *)otherCards;

@end
