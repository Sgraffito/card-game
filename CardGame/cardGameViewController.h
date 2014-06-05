//
//  cardGameViewController.h
//  CardGame
//
//  Created by Nicole on 5/13/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//
//  Abstract class. Must implement methods as described below.

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface cardGameViewController : UIViewController

// Protected
// For subclasses
- (Deck *)createDeck; // Abstract

- (UIImage *)backgroundImageForCard:(Card *)card; // Abstract
- (NSAttributedString *)titleForCard:(Card *)card; // Abstract
- (int)cardMatchingCount; //Abstract

@end
