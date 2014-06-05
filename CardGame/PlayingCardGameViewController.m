//
//  PlayingCardGameViewController.m
//  CardGame
//
//  Created by Nicole on 6/2/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

- (Deck *)createDeck {
    return [[PlayingCardDeck alloc] init];
}

- (UIImage *)backgroundImageForCard:(Card *)card {
    
    /* If card is choosen, display card front image. If card is not choosen, choose
     * card back image */
    return [UIImage imageNamed:card.isChoosen ? @"cardfront" : @"cardbackbeetle"];
}

- (NSAttributedString *)titleForCard:(Card *)card {
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:card.contents];
    
    // Set text color for the title (red for hearts and diamonds and black for spades and clubs)
    [title setAttributes:@ { NSForegroundColorAttributeName : card.color }
                   range:NSMakeRange(0, [title length])];
    
    NSMutableAttributedString *noTitle = [[NSMutableAttributedString alloc] initWithString:@""];
    
    // If card is choosen, display the card's number and suit, otherwise display nothing
    if (card.isChoosen) {
        return title;
    }
    return noTitle;
}


- (int)cardMatchingCount { // Abstract
    return 2;
}

@end
