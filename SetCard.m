//
//  SetCard.m
//  CardGame
//
//  Created by Nicole on 6/2/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

// Because we provide setter AND getter
@synthesize symbol = _symbol;
@synthesize color = _color;
@synthesize shading = _shading;

- (int)match:(NSArray *)otherCards {
    
    // If no cards are matched score is zero
    int score = 0;
    
    if ([otherCards count] == 3) {
        
        SetCard *firstCard = [otherCards objectAtIndex:0];
        SetCard *secondCard = [otherCards objectAtIndex:1];
        SetCard *thirdCard = [otherCards objectAtIndex:2];
        
        // Check to see if all the colors are the same or are all different
        if (([firstCard.color isEqual:secondCard.color]
             && [firstCard.color isEqual:thirdCard.color]
             && [secondCard.color isEqual:thirdCard.color])
            ||
            (![firstCard.color isEqual:secondCard.color]
             && ![firstCard.color isEqual:thirdCard.color]
             && ![secondCard.color isEqual:thirdCard.color])) {
                score += 3;
            }
        // If the colors are not all the same or all different, there is no match, exit
        else {
            return 0;
        }
        
        // Check to see if all the shadings are the same or are all different
        if (([firstCard.shading isEqualToString:secondCard.shading]
             && [firstCard.shading isEqualToString:thirdCard.shading]
             && [secondCard.shading isEqualToString:thirdCard.shading])
            ||
            (![firstCard.shading isEqualToString:secondCard.shading]
             && ![firstCard.shading isEqualToString:thirdCard.shading]
             && ![secondCard.shading isEqualToString:thirdCard.shading])) {
                score += 3;
            }
        
        // If the shadings are not all the same or all different, there is no match, exit
        else {
            return 0;
        }
        
        // Check to see if all the symbols are the same or all different
        if (([firstCard.symbol isEqualToString:secondCard.symbol]
             && [firstCard.symbol isEqualToString:thirdCard.symbol]
             && [secondCard.symbol isEqualToString:thirdCard.symbol])
            ||
            (![firstCard.symbol isEqualToString:secondCard.symbol]
             && ![firstCard.symbol isEqualToString:thirdCard.symbol]
             && ![secondCard.symbol isEqualToString:thirdCard.symbol])) {
                score += 3;
            }
        
        // If the symbols are not all the same or all different, there is no match, exit
        else {
            return 0;
        }
        
        // Check to see if all the numbers are the same or all different
        if ((firstCard.number == secondCard.number
             && firstCard.number == thirdCard.number
             && secondCard.number == thirdCard.number)
            ||
            (firstCard.number != secondCard.number
             && firstCard.number != thirdCard.number
             && secondCard.number != thirdCard.number)) {
                score += 3;
            }
        
        // IF the numbers are not all the same or all different, there is no match, exit
        else {
            return 0;
        }
    }
    
    return score;
}

- (NSString *)createTitle:(NSArray *)otherCards {
    
    NSString *title = @"";
    
    if ([otherCards count] == 2) {
        title = [NSString stringWithFormat:@"%@ %@", [otherCards.firstObject contents], [otherCards.lastObject contents]];
    }
    
    if ([otherCards count] == 3) {
        
        SetCard *firstCard = [otherCards objectAtIndex:0];
        SetCard *secondCard = [otherCards objectAtIndex:1];
        SetCard *thirdCard = [otherCards objectAtIndex:2];
        
        title = [NSString stringWithFormat:@"%@ %@ %@", firstCard.contents, secondCard.contents, thirdCard.contents];
    }
    
    return title;
}

- (NSString *)contents {
    
    NSString *cardContents = [[NSString alloc] init];
    NSUInteger count = self.number;
    while (count) {
        cardContents = [cardContents stringByAppendingString:self.symbol];
        count -= 1;
    }
    return cardContents;
}

- (UIColor *)color {
    return _color;
}

- (NSString *)shading {
    return _shading;
}

// Class method
+ (NSArray *)validSymbols {
    return @[@"▲", @"●", @"◼︎"];
}

+ (NSArray *)numberStrings {
    return @[@"?", @"1", @"2", @"3"];
}

+ (NSArray *)colorValues {
    UIColor *purple = [UIColor colorWithRed:114/255.0 green:9/255.0 blue:178/255.0 alpha:1.0];
    UIColor *red = [UIColor colorWithRed:207/255.0 green:31/255.0 blue:10/255.0 alpha:1.0];
    UIColor *green = [UIColor colorWithRed:16/255.0 green:140/255.0 blue:11/255.0 alpha:1.0];
    return @[purple, red, green];
}

+ (NSArray *)shadingStrings {
    return @[@"solid", @"outline", @"open"];
}

//Check to make sure no one tries to set a suit to something invalid
- (void)setSymbol:(NSString *)symbol {
    if ([[SetCard validSymbols] containsObject:symbol]) {
        _symbol = symbol;
    }
}

// A symbol of nil returns "?"
- (NSString *)symbol {
    return _symbol ? _symbol : @"?";
}

+ (NSUInteger)maxNumber {
    return [[self numberStrings] count] - 1;
}

// Make sure rank is never set to an improper value
- (void)setNumber:(NSUInteger)number {
    if (number <= [SetCard maxNumber]) {
        _number = number;
    }
}

// Make sure color is never set to an improper value
- (void)setColor:(UIColor *)color {
    if ([[SetCard colorValues] containsObject:color]) {
        _color = color;
    }
}

// Make sure shading is never set to an improper value
- (void)setShading:(NSString *)shading {
    if ([[SetCard shadingStrings] containsObject:shading]) {
        _shading = shading;
    }
}

@end
