//
//  cardGameViewController.m
//  CardGame
//
//  Created by Nicole on 5/13/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "cardGameViewController.h"
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

- (void)viewDidLoad {
    [self updateUI];
    
    // Set the tint color for the tab bar
    [self.tabBarController.tabBar setTintColor:[UIColor blackColor]];
}

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

- (Deck *)createDeck { // Abstract
    return nil;
}

// User clicks on a card
- (IBAction)touchCardButton:(UIButton *)sender {
    int choosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:choosenButtonIndex];
    [self updateUI];
}

- (void)updateUI {
    
    //Get the number of cards to be matched
    [self.game setCardMatchingCount:[self cardMatchingCount]];
    
    // Set the format for each card
    for (UIButton *cardButton in self.cardButtons) {
        
        // Get the contents of the card clicked on by the user
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        
        // Set the title of the card
        [cardButton setAttributedTitle:[self titleForCard:card] forState:UIControlStateNormal];
        
        // Set the background color of the card
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        
        // Unmatched cards are clickable, matched cards are not clickable
        cardButton.enabled = !card.isMatched;
    }
    
    // Label that shows the score of the game
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    
    // Label that shows the cards selected and if they match or not
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
    
    //Check to see if game has ended
    if (self.cardsStillInPlay) {
        self.cardChoice.text = @"No more matching cards. Game over";
        
        // Disable all the buttons
        for (UIButton *cardButton in self.cardButtons) {
            cardButton.enabled = NO;
        }
        
        // Change score text to final
        self.scoreLabel.text = [NSString stringWithFormat:@"Final score: %d", self.game.score];
    }
    
    // Reset redeal to 0
    self.redeal = 0;
}

// Get the title for the text of the card
- (NSAttributedString *)titleForCard:(Card *)card { // Abstract
    return nil;
}

// Get the background image for the card
- (UIImage *)backgroundImageForCard:(Card *)card { //Abstract
    return nil;
}

// Create a new deck of cards
- (IBAction)redeal:(id)sender {
    self.redeal = 1;
    _game = [[CardMatchingGame alloc]
             initWithCardCount:[self.cardButtons count]
             usingDeck:[self createDeck]];
    [self updateUI];
}

/* Check the segmented control to see how many card to match (deleted from storyboard)
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
 
 //Segmented control (deleted from storyboard)
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
 */

- (int)cardMatchingCount { // Abstract
    return 0;
}

// Check to see if game has ended
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
    
    // If the game has ended, return true
    if ([self.game endOfGame:cardsNotMatched]) {
        return true;
    }
    
    // If the game has not ended, return false
    return  false;
}

@end
