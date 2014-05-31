//
//  PlayingCard.m
//  CardGame
//
//  Created by Nicole on 5/13/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "PlayingCard.h"

@interface PlayingCard()
@property (nonatomic) NSUInteger count;
@end

@implementation PlayingCard

// Because we provide setter AND getter
@synthesize suit = _suit;

- (int)match:(NSArray *)otherCards {
    int score = 0;
        
    if ([otherCards count] == 2) {

        PlayingCard *firstCard = [otherCards firstObject];
        PlayingCard *secondCard = [otherCards lastObject];
        
        if (firstCard.rank == secondCard.rank) {
            score = 4;
        }
        else if ([firstCard.suit isEqualToString:secondCard.suit]) {
            score = 1;
        }
    }
    
    else if ([otherCards count] == 3) {
        
        PlayingCard *firstCard = [otherCards objectAtIndex:0];
        PlayingCard *secondCard = [otherCards objectAtIndex:1];
        PlayingCard *thirdCard = [otherCards objectAtIndex:2];
       
        // If all three cards have the same rank
        if (firstCard.rank == thirdCard.rank && secondCard.rank == thirdCard.rank && firstCard.rank == secondCard.rank) {
            score = 15;
        }
        
        // If all three cards have the same suit
        if (firstCard.suit == thirdCard.suit && secondCard.suit == thirdCard.suit && firstCard.suit == secondCard.suit) {
            score = 10;
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
       
        PlayingCard *firstCard = [otherCards objectAtIndex:0];
        PlayingCard *secondCard = [otherCards objectAtIndex:1];
        PlayingCard *thirdCard = [otherCards objectAtIndex:2];

        title = [NSString stringWithFormat:@"%@ %@ %@", firstCard.contents, secondCard.contents, thirdCard.contents];
    }
    
    return title;
}

- (BOOL)checkIfGameOver:(NSArray *)otherCards {

    return false;
}

- (NSString *)contents {
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

// Class method
+ (NSArray *)validSuits {
    return @[@"♥︎", @"♣︎", @"♦︎", @"♠︎"];
}

+ (NSArray *)rankStrings {
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

//Check to make sure no one tries to set a suit to something invalid
- (void)setSuit:(NSString *)suit {
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

// A suit of nil returns ?
- (NSString *)suit {
    return _suit ? _suit : @"?";
}

+ (NSUInteger)maxRank {
    return [[self rankStrings] count] - 1;
}

// Make sure rank is never set to an improper value
- (void)setRank:(NSUInteger)rank {
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@end
