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
            
            // If 2 or 3 cards have been picked by the user (depending on the the game settings)
            if ([self.setOfCards count] == self.cardMatchingCount) {
                                
                // Get the score
                int matchScore = [card match:self.setOfCards];
                
                // If a match has occured...
                if (matchScore) {
                    
                    // Calculate the score
                    self.score += matchScore * MATCH_BONUS;
                    
                    // Create a title
                    self.matchingAnnoucement = [[NSMutableAttributedString alloc] initWithString:@""];
                    NSString *string1 = [NSString stringWithFormat:@"Matched "];
                    NSAttributedString *cardChoice = [[NSAttributedString alloc] initWithAttributedString:[card createTitle:self.setOfCards]];
                    NSString *string2 = [NSString stringWithFormat:@"for %d points", (matchScore * MATCH_BONUS)];
                    NSAttributedString *substring1 = [[NSAttributedString alloc] initWithString:string1];
                    NSAttributedString *substring2 = [[NSAttributedString alloc] initWithString:string2];
                    [self.matchingAnnoucement appendAttributedString:substring1];
                    [self.matchingAnnoucement appendAttributedString:cardChoice];
                    [self.matchingAnnoucement appendAttributedString:substring2];
                    
                    // Mark the card as matched
                    for (Card *matchedCard in self.setOfCards) {
                        for (Card *setOfCard in self.cards) {
                            if ([matchedCard.contents isEqualToString:setOfCard.contents]
                                && [matchedCard.shading isEqualToString:setOfCard.shading]
                                && [matchedCard.color isEqual:setOfCard.color]) {
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
                    self.matchingAnnoucement = [[NSMutableAttributedString alloc] initWithString:@""];
                    NSAttributedString *cardChoice = [[NSAttributedString alloc] initWithAttributedString:[card createTitle:self.setOfCards]];
                    NSString *string1 = [NSString stringWithFormat:@"do not match. Loose %d points", MISMATCH_PENALTY];
                    NSAttributedString *substring1 = [[NSAttributedString alloc] initWithString:string1];
                    [self.matchingAnnoucement appendAttributedString:cardChoice];
                    [self.matchingAnnoucement appendAttributedString:substring1];

                    // Old title
                    //self.matchingAnnoucement = [NSString stringWithFormat:@"%@ do not match. Loose %d points", [card createTitle:self.setOfCards], MISMATCH_PENALTY];
                    
                    // Turn the cards back over
                    for (Card *matchedCard in self.setOfCards) {
                        for (Card *setOfCards in self.cards) {
                            if ([matchedCard.contents isEqualToString:setOfCards.contents]
                                && [matchedCard.shading isEqualToString:setOfCards.shading]
                                && [matchedCard.color isEqual:setOfCards.color]) {
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
                        if ([setOfCards.contents isEqualToString:card.contents]
                            && [setOfCards.shading isEqualToString:card.shading]
                            && [setOfCards.color isEqual:card.color]) {
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
    Card *card = [unmatchedCards objectAtIndex:0];
    
    // If the game is over, return true
    if ([card isGameOver:unmatchedCards]) {
        return true;
    }
    
    // If the game is not over, return false
    return false;
}

- (Card *)cardAtIndex:(NSUInteger)index {
    return (index < [self.cards count]) ? self.cards[index] : nil;
}


@end
