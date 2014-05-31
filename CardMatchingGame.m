//
//  CardMatchingGame.m
//  CardGame
//
//  Created by Nicole on 5/16/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards; // Of Card
@property (nonatomic, strong) NSMutableArray *setOfCards; // Of Card
@end

@implementation CardMatchingGame

// Getter for setofCards
- (NSMutableArray *)setOfCards {
    if (!_setOfCards) _setOfCards = [[NSMutableArray alloc] init];
    return _setOfCards;
}

// Getter for cards
- (NSMutableArray *)cards {
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck {
    self = [super init]; //Super's designated initializer
   
    if (self) {
        for (int i = 0; i < count; i += 1) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            }
            else {
                self = nil;
                break;
            }
        }
    }
    
    return self;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

- (void)chooseCardAtIndex:(NSUInteger)index {
    
    // Get the card at the index
    Card *card = [self cardAtIndex:index];
    
    // Check to see if the card is unmatched
    if (!card.isMatched) {
        
        // If the card has already been selected by the user, unselect it
        if (card.isChoosen) {
            card.chosen = NO;
            [self.setOfCards removeObject:card];
        }
        
        // If the card has not been choosen
        else {
            
            // Mark the card as choosen
            card.chosen = YES;
            
            // Add it to an array of card to match
            [self.setOfCards addObject:card];
            
            // If 2 or 3 cards have been picked by the user (depeding the the game settings)
            if ([self.setOfCards count] == self.cardMatchingCount) {
                
                // Get the score
                int matchScore = [card match:self.setOfCards];
                
                // If a match has occured...
                if (matchScore) {
                    
                    // Calculate the score
                    self.score += matchScore * MATCH_BONUS;
                    
                    // Create a title
                    self.matchingAnnoucement = [NSString stringWithFormat:@"Matched %@ for %d points", [card createTitle:self.setOfCards], (matchScore * MATCH_BONUS)];
                    
                    // Mark the card as matched
                    for (Card *matchedCard in self.setOfCards) {
                        for (Card *setOfCard in self.cards) {
                            if ([matchedCard.contents isEqualToString:setOfCard.contents]) {
                                setOfCard.matched = YES;
                            }
                        }
                    }
                    
                    // Remove all cards from the cards to match array
                    [self.setOfCards removeAllObjects];
                }
                
                // If no match has occured...
                else {

                    // Calculate the score
                    self.score -= MISMATCH_PENALTY;
                    
                    // Create a title
                    self.matchingAnnoucement = [NSString stringWithFormat:@"%@ do not match. Penalty of %d points", [card createTitle:self.setOfCards], MISMATCH_PENALTY];
                    
                    // Turn the cards back over
                    for (Card *matchedCard in self.setOfCards) {
                        for (Card *setOfCards in self.cards) {
                            if ([matchedCard.contents isEqualToString:setOfCards.contents]) {
                                setOfCards.matched = NO;
                                setOfCards.chosen = NO;
                            }
                        }
                    }
                
                    // Remove all objects from the card to match array
                    [self.setOfCards removeAllObjects];
                    
                    /* Keep the contents of the last card choosen by the user visible and
                     * add the card to the cards to match array */
                    for (Card *setOfCards in self.cards) {
                        if ([setOfCards.contents isEqualToString:card.contents]) {
                            setOfCards.chosen = YES;
                            [self.setOfCards addObject:setOfCards];
                        }
                    }
                }
            }
        }
        
        // Enact a penalty for turning over a card
        self.score -= COST_TO_CHOOSE;
    }
}

- (BOOL)endOfGame:(NSArray *)unmatchedCards {
    
    NSMutableDictionary *unmatchedSuit = [[NSMutableDictionary alloc] init]; // Of Card
    NSMutableDictionary *unmatchedRank = [[NSMutableDictionary alloc] init]; // Of Card

    // Find all the cards that have not been matched
    for (PlayingCard *card in unmatchedCards) {
        
        // If the suit is already in the Dictionary, increase the total count of the suit by 1
        if ([unmatchedSuit objectForKey:card.suit]) {
            NSString *stringCount = [unmatchedSuit objectForKey:card.suit];
            NSInteger count = [stringCount integerValue];
            count += 1;
            [unmatchedSuit setObject:[NSNumber numberWithInt:count] forKey:card.suit];
        }
        
        // If the suit is not in the Dictionary, add it to the Dictionary
        else {
            unmatchedSuit[card.suit] = [NSNumber numberWithInt:1];
        }
        
        
        // If the rank is already in the Dictionary, increase the total count of the rank by one
        if ([unmatchedRank objectForKey:[NSNumber numberWithInt:card.rank]]) {
            NSString *stringCount = [unmatchedRank objectForKey:[NSNumber numberWithInt:card.rank]];
            NSInteger count = [stringCount integerValue];
            count +=1;
            [unmatchedRank setObject:[NSNumber numberWithInt:count] forKey:[NSNumber numberWithInt:card.rank]];
        }
        
        // If the rank is not in the Dictionary, add it to the Dictionary
        else {
            unmatchedRank[[NSNumber numberWithInt:card.rank]] = [NSNumber numberWithInt:1];
        }
    }

    // Check to see if there are matching suits left
    for (id key in unmatchedSuit) {
        NSString *stringCount = unmatchedSuit[key];
        NSInteger count = [stringCount integerValue];
        
        if (self.cardMatchingCount == 2) {
            if (count >= 2) {
                return true;
            }
        }
        
        else if (self.cardMatchingCount == 3) {
            if (count >= 3) {
                return true;
            }
        }
    }
    
    // Check to see if there are matching ranks left
    for (id key in unmatchedRank) {
        NSString *stringCount = unmatchedRank[key];
        NSInteger count = [stringCount integerValue];
        
        if (self.cardMatchingCount == 2) {
            if (count >= 2) {
                return true;
            }
        }
        
        else if (self.cardMatchingCount == 3) {
            if (count >= 3)  {
                return true;
            }
        }
    }
    
    // If there are not more than two cards of the same rank or suit, end the game
    return false;
}

- (Card *)cardAtIndex:(NSUInteger)index {
    return (index < [self.cards count]) ? self.cards[index] : nil;
}


@end
