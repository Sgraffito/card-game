//
//  cardGameViewController.m
//  CardGame
//
//  Created by Nicole on 5/13/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "cardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface cardGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *changeSegmentIndex;
@property (strong, nonatomic) NSMutableArray *selectedCards;
@property (nonatomic) NSUInteger redeal;
@property (weak, nonatomic) IBOutlet UILabel *cardChoice;
@property (weak, nonatomic) IBOutlet UILabel *numberOfCardsToMatchLabel;
@end

@implementation cardGameViewController

- (NSMutableArray *)selectedCards {
    if (!_selectedCards) _selectedCards = [[NSMutableArray alloc] init];
    return _selectedCards;
}

- (CardMatchingGame *)game {
    if (!_game) _game = [[CardMatchingGame alloc]
                         initWithCardCount:[self.cardButtons count]
                         usingDeck:[self createDeck]];
    return _game;
}

- (Deck *)createDeck {
    return [[PlayingCardDeck alloc] init];
}

- (IBAction)touchCardButton:(UIButton *)sender {
    int choosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:choosenButtonIndex];
    [self updateUI];
}

- (void)updateUI {
    
    //Get the number of cards to be matched
    [self.game setCardMatchingCount:[self checkCardMatchingCount]];
    
    // Set the format for each card
    for (UIButton *cardButton in self.cardButtons) {
        
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        
        // Set color of text
        if ([self colorOfCard:card]) {
            [cardButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        else {
            [cardButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        
    }
        
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.cardChoice.text = self.game.matchingAnnoucement;

    // While game is being played, grey out the UISegmentControl
    if (self.redeal == 0) {
        self.changeSegmentIndex.userInteractionEnabled = NO;
        self.changeSegmentIndex.alpha = 0.5;
    }
    
    // If user clicks redeal, make the UISegmentControl clickable
    else {
        self.changeSegmentIndex.userInteractionEnabled = YES;
        self.changeSegmentIndex.alpha = 1.0;
    }
    
    // Check to see if game has ended
    if (!self.cardsStillInPlay) {
        self.cardChoice.text = @"No more matching cards. Game over";
        
        // Disable all the buttons
        for (UIButton *cardButton in self.cardButtons) {
            cardButton.enabled = NO;
        }
        
        // Change score text to final
        self.scoreLabel.text = [NSString stringWithFormat:@"Final score is: %d", self.game.score];
    }

    // Reset redeal to 0
    self.redeal = 0;
}

- (NSString *)titleForCard:(Card *)card {
    
    // If card is choosen, display the card's number and suit, otherwise display nothing
    return card.isChoosen ? card.contents : @"";
}

// Determine the color of the card (red if suit is heart or diamond, black if clubs or spade)
- (BOOL)colorOfCard:(Card *)card {
    
    // Check if card's suit is a heart
    NSString *string = card.contents;
    NSRange rangeValue = [string rangeOfString:@"♥︎" options:NSCaseInsensitiveSearch];
    if (rangeValue.length > 0) {
        return YES;
    }
    
    // Check if card's suit is a diamond
    NSRange rangeValue2 = [string rangeOfString:@"♦︎" options:NSCaseInsensitiveSearch];
    if (rangeValue2.length > 0) {
        return YES;
    }
    
    // If card's suit is not a diamond or heart, return false
    return NO;
}

- (UIImage *)backgroundImageForCard:(Card *)card {
    
    /* If card is choosen, display card front image. If card is not choosen, choose
     * card back image */
    return [UIImage imageNamed:card.isChoosen ? @"cardfront" : @"cardback"];
}

- (NSUInteger)checkCardMatchingCount {
    
    // Default is matching 2 cards
    NSUInteger cardMatchingCount = 2;
    
    // Match 2 cards
    if (self.changeSegmentIndex.selectedSegmentIndex == 0) {
        cardMatchingCount = 2;
    }
    
    // Match 3 cards
    else if (self.changeSegmentIndex.selectedSegmentIndex == 1) {
        cardMatchingCount = 3;
    }

    return cardMatchingCount;
}

// Create a new deck of cards
- (IBAction)redeal:(id)sender {
    self.redeal = 1;
    _game = [[CardMatchingGame alloc]
                         initWithCardCount:[self.cardButtons count]
                         usingDeck:[self createDeck]];
    [self updateUI];
}

- (IBAction)cardMatchingCount:(id)sender {
    
    // Match 2 cards
    if (self.changeSegmentIndex.selectedSegmentIndex == 0) {
        self.numberOfCardsToMatchLabel.text = [NSString stringWithFormat:@"Match 2 cards"];
    }
    
    // Match 3 cards
    else if (self.changeSegmentIndex.selectedSegmentIndex == 1) {
        self.numberOfCardsToMatchLabel.text = [NSString stringWithFormat:@"Match 3 cards"];
    }
}

- (BOOL)cardsStillInPlay {
    
    NSMutableArray *cardsNotMatched = [[NSMutableArray alloc] init];

    // Find all unmatched buttons and add them to an array
    for (UIButton *cardButton in self.cardButtons) {
        
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        
        // Add all unmatched buttons to an array
        if (!card.isMatched) {
            [cardsNotMatched addObject:card];
        }
    }

    if ([self.game endOfGame:cardsNotMatched]) {
        return true;
    }
    
    return  false;
}

@end
