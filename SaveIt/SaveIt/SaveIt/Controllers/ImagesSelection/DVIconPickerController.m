//
//  DVIconPickerControllerViewController.m
//  SaveIt
//
//  Created by Bharath Booshan on 6/26/12.
//  Copyright (c) 2012 Integral Development Corporation. All rights reserved.
//

#import "DVIconPickerController.h"
#import "DVImageManager.h"
#import "DVUtilities.h"
#import "UIImage+Loader.h"

#define TOTAL_IMAGE_COLUMNS 4
#define IMAGE_CELL_HEIGHT 60.0
#define IMAGE_CELL_WIDTH 60.0

@interface DVIconPickerController ()
{
    DVImageManager *_sharedImageManager;
    UIBarButtonItem *_addButton;
}
@end

@implementation DVIconPickerController
@synthesize pickerDelegate = _pickerDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _sharedImageManager = [DVImageManager sharedManager];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Select Icon";
    
    // Do any additional setup after loading the view from its nib.
    mIconGridView = [[DTGridView alloc] initWithFrame:self.view.bounds];
    mIconGridView.autoresizingMask = self.view.autoresizingMask;
    mIconGridView.delegate = self;
    mIconGridView.dataSource = self;
    mIconGridView.backgroundColor = [UIColor colorWithRed:1.0 green:254.0/255.0 blue:200.0/255.0 alpha:1.0];
    float cellOffset = (self.view.frame.size.width - (IMAGE_CELL_WIDTH * TOTAL_IMAGE_COLUMNS))/ (TOTAL_IMAGE_COLUMNS+1);
    mIconGridView.cellOffset = CGPointMake(cellOffset , cellOffset);
    mIconGridView.initialYOffset = 10.0;
    [self.view addSubview:mIconGridView];
    
    _addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showPhotoOptions:)];
    [self.navigationItem setRightBarButtonItem:_addButton];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    mIconGridView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)showImages
{
    [_sharedImageManager loadImageFromDirectory:[DVUtilities getIconsDirectory] completionBlock:^(BOOL completed){
        [mIconGridView reloadData]; 
    }];
}

- (void)showPhotoOptions:(id)sender
{
    UIActionSheet *photoOptions = nil;
    
    if( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] )
    {
       photoOptions=  [[UIActionSheet alloc] initWithTitle:@"How do you like to add Icons?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"From Camera", @"From Photo Library", @"I want to Edit Icons" ,nil];
    }
    else {
        photoOptions = [[UIActionSheet alloc] initWithTitle:@"How do you like to add Icons?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles: @"From Photo Library", @"I want to Edit Icons" ,nil];
    }
    [photoOptions showInView:self.tabBarController.view];
}

#pragma DTGridView Protocol
- (NSInteger)numberOfRowsInGridView:(DTGridView *)gridView
{
    return [_sharedImageManager totalImages];
}
/*!
 @abstract Asks the data source to return the number of columns for the given row in the grid view.
 @para The grid view object requesting this information.
 @para The index of the given row.
 @return The number of colums in the row of the grid view.
 */
- (NSInteger)numberOfColumnsInGridView:(DTGridView *)gridView forRowWithIndex:(NSInteger)index
{
    NSUInteger totalImages =  [_sharedImageManager totalImages];
    return MIN(TOTAL_IMAGE_COLUMNS, totalImages - (index * TOTAL_IMAGE_COLUMNS));
}

- (CGFloat)gridView:(DTGridView *)gridView heightForRow:(NSInteger)rowIndex
{
    return IMAGE_CELL_HEIGHT;
}

- (CGFloat)gridView:(DTGridView *)gridView widthForCellAtRow:(NSInteger)rowIndex column:(NSInteger)columnIndex
{
    return IMAGE_CELL_WIDTH;
}

- (DTGridViewCell *)gridView:(DTGridView *)gridView viewForRow:(NSInteger)rowIndex column:(NSInteger)columnIndex
{
    DTGridViewCell *cell = [gridView dequeueReusableCellWithIdentifier:@"image_cell"];
    
	if (!cell) {
		cell = [[DTGridViewCell alloc] initWithReuseIdentifier:@"image_cell"];
        cell.gridCellType = eGridCellImageType;
	}
    
    NSUInteger index = (rowIndex * TOTAL_IMAGE_COLUMNS) + columnIndex;
    NSString *imagePath = [_sharedImageManager imagePathAtIndex:index];
    cell.imageView.image = [UIImage imageFromDocuments:imagePath];
	return cell;
}

- (void)gridView:(DTGridView *)gridView selectionMadeAtRow:(NSInteger)rowIndex column:(NSInteger)columnIndex
{
    NSUInteger index = (rowIndex * TOTAL_IMAGE_COLUMNS) + columnIndex;
    NSString *imagePath = [_sharedImageManager imagePathAtIndex:index];
    [self.pickerDelegate iconPicker:self didSelectImage:[UIImage imageFromDocuments:imagePath] withName:imagePath];
}

#pragma UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] )
    {
        switch (buttonIndex) {
            case 0://Add From Camera
            {
                [DVUtilities showCameraInViewController:self];
            }
                break;
            case 1://Add from Library
            {
                [DVUtilities showPhotoLibrary:self];
            }
                break;
                
            case 2://Edit
            {
                
            }
                break;
            default:
                break;
        }
    }
    else {
        switch (buttonIndex) {
            case 0://Add From Library
            {
                [DVUtilities showPhotoLibrary:self];
            }
                break;
            case 1://Edit
            {
                
            }
                break;
             default:
                break;
        }
    }

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    //to avoid the mIconGridView to be copied.
    __weak DTGridView *gridView = mIconGridView;
    __weak UIViewController *controller = self;
    [_sharedImageManager addImage:selectedImage completionBlock:^(BOOL complete){
        [controller dismissModalViewControllerAnimated:YES];
        [gridView performSelector:@selector(reloadData) withObject:nil afterDelay:1.0];
    }];
}



@end
