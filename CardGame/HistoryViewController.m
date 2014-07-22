//
//  HistoryViewController.m
//  CardGame
//
//  Created by Nicole on 6/13/14.
//  Copyright (c) 2014 nicole. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()
@property (weak, nonatomic) IBOutlet UITextView *listOfFinishedGames;
@end

@implementation HistoryViewController

@synthesize finishedGames = _finishedGames;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set UITextView to empty text
    self.listOfFinishedGames.text = @"";
    
    // Get rid of the text margin on top of UITextView
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    /* Test
    self.listOfFinishedGames.text = @"";
    NSString *one = @"Keweenaw";
    NSString *two = @"Lake Linden";
    NSString *three = @"Calumet";
    [self.finishedGames addObject:one];
    [self.finishedGames addObject:two];
    [self.finishedGames addObject:three];
    */
    [self updateUI];
}

- (void)setFinishedGames:(NSMutableArray *)finishedGames {
    _finishedGames = [[NSMutableArray alloc] initWithArray:finishedGames];
    if (self.view.window) [self updateUI];
}

- (NSMutableArray *)finishedGames {
    if (!_finishedGames) _finishedGames = [[NSMutableArray alloc] init];
    return _finishedGames;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUI];
}

- (void)updateUI {
    if ([self.finishedGames count] != 0) {
        
        // Reset the UITextView text to empty
        self.listOfFinishedGames.text = @"";
        
        // Print all the statments in the array
        for (NSString *string in self.finishedGames) {
            self.listOfFinishedGames.text = [self.listOfFinishedGames.text stringByAppendingString:string];
            self.listOfFinishedGames.text = [self.listOfFinishedGames.text stringByAppendingString:@"\n"];
        }
    }
}

@end
