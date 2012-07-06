//
//  DVFieldEditorController.m
//  SaveIt
//
//  Created by Bharath Booshan on 7/3/12.
//  Copyright (c) 2012 Integral Development Corporation. All rights reserved.
//

#import "DVFieldEditorController.h"

@interface DVFieldEditorController ()
@end

@implementation DVFieldEditorController
@synthesize isScrambled;
@synthesize fieldEditorDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setIsScrambled:(BOOL)scramble
{
    isScrambled = scramble;
    [mFieldScrambleImageView setImage: isScrambled ? [UIImage imageNamed:@"Lock_icon.png"] : [UIImage imageNamed:@"unlock.png"]];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Edif Field Info";
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [mFieldValueField becomeFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)scramble:(id)sender
{
   self.isScrambled =  !isScrambled;
}

- (void)editWithFieldName:(NSString *)fieldName fieldValue:(NSString *)fieldValue scramble:(BOOL)scramble
{
    self.isScrambled = scramble;
    [mFieldNameField setText:fieldName];
    [mFieldValueField setText:fieldValue];
}

- (void)done:(id)sender
{
    [self.fieldEditorDelegate fieldEditor:self didEditFieldName:mFieldNameField.text fieldValue:mFieldValueField.text scramble:isScrambled];
}

- (void)cancel:(id)sender
{
    [self.fieldEditorDelegate fieldEditorDidCancel:self];
}



@end
