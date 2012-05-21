//
//  DVUtilities.m
//  SaveIt
//
//  Created by Bhagya on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DVUtilities.h"

@implementation DVUtilities
+(NSString *)getDocumentsDirectory
{
	static NSString *documentsDirectory = nil;
	if( !documentsDirectory )
	{
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		documentsDirectory = [paths objectAtIndex:0];	   	
	}
	return documentsDirectory;
}
@end
