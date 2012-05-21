//
//  DVViewController.m
//  SaveIt
//
//  Created by Bhagya on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DVViewController.h"
#import "DVCategoryManager.h"
#import "DVCategory.h"

@interface DVViewController ()
{
    DVCategoryManager *categoryManager ;
    
}
@end

@implementation DVViewController

- (void)viewDidLoad
{
 
    categoryManager = [[DVCategoryManager alloc] init];
    [categoryManager registerForUpdates:@selector(catUpdate:) target:self];
    [categoryManager loadCategories:^(BOOL finished){
    }];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(IBAction)add:(id)sender
{
    DVCategory *cat = [DVCategory newCategory];
    cat.categoryName = @"New cat";
    [categoryManager   addCategory:cat];
    
}

-(IBAction)deleteCategory:(id)sender
{
    if ([categoryManager totalCategories] )
    {
        DVCategory *cat = [categoryManager categoryAtIndex:0];
        [categoryManager removeCategory:cat];

    }
}

-(void)catUpdate:(NSNotification*)notif
{
    NSLog(@"%d", [categoryManager totalCategories]);
}

@end
