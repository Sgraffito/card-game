//
//  SetCardGameViewController.m
//  CardGame
//
//  Created by Nicole on 6/2/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"

@interface SetCardGameViewController ()

@end

@implementation SetCardGameViewController

- (Deck *)createDeck {
    return [[SetCardDeck alloc] init];
}

- (UIImage *)backgroundImageForCard:(Card *)card {
    
    // If card is choosen, background is blue. If card is not choosen, background is white
    return [UIImage imageNamed:card.isChoosen ? @"cardbackcolor" : @"cardfront"];
}

- (NSAttributedString *)titleForCard:(Card *)card {
    
    // Initialize a title
    NSMutableAttributedString *title =
    [[NSMutableAttributedString alloc] initWithString:card.contents];
    
    // Create title if the shape is outlined (shape is outline with no fill)
    if ([card.shading isEqualToString:@"outline"]) {
        [title setAttributes:@ { NSStrokeWidthAttributeName : @8,
            NSStrokeColorAttributeName : card.color }
                       range:NSMakeRange(0, [title length])];
    }
    
    // Create title if the shape is solid (ouline and fill are same color and transparency)
    else if([card.shading isEqualToString:@"solid"]) {
        [title setAttributes:@ { NSStrokeWidthAttributeName : @-8,
            NSStrokeColorAttributeName : card.color,
            NSForegroundColorAttributeName : card.color }
                       range:NSMakeRange(0, [title length])];
    }
    
    // Create title if shape is open (outlined shape with transparent fill)
    else if([card.shading isEqualToString:@"open"]) {
        UIColor *solidColor = card.color;
        UIColor *transparentColor = [solidColor colorWithAlphaComponent:0.2];
        [title setAttributes:@ { NSStrokeWidthAttributeName : @-8,
            NSStrokeColorAttributeName : solidColor,
            NSForegroundColorAttributeName : transparentColor}
                       range:NSMakeRange(0, [title length])];
        
    }
    
    // Always display the card's contents
    return title;
}

- (UIColor *)colorOfCard:(Card *)card {
    
    // Get the color of the card
    return card.color;
}

- (int)cardMatchingCount {
    return 3;
}

@end
