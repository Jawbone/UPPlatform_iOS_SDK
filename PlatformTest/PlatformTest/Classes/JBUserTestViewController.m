//
//  JBPlatformTestViewController.m
//  PlatformTest
//
//  Created by Andy Roth on 5/29/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import "JBUserTestViewController.h"

#import "UP.h"

@interface JBUserTestViewController ()

@end

@implementation JBUserTestViewController

#pragma mark - User

- (void)getUserInfo
{
	[UPUserAPI getCurrentUserWithCompletion:^(UPUser *user, UPURLResponse *response, NSError *error) {
		[self showResults:user];
	}];
}

- (void)getFriends
{
	[UPUserAPI getFriendsWithCompletion:^(NSArray *friends, UPURLResponse *response, NSError *error) {
		[self showResults:friends];
	}];
}

- (void)getTrends
{
	[UPUserAPI getTrendsWithEndDate:nil rangeType:UPUserTrendsRangeTypeDays rangeDuration:14 bucketSize:UPUserTrendsBucketSizeDays completion:^(NSArray *trends, UPURLResponse *response, NSError *error) {
		[self showResults:trends];
	}];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.row)
	{
		case 0:
			[self getUserInfo];
			break;
			
		case 1:
			[self getFriends];
			break;
			
		case 2:
			[self getTrends];
			break;
			
		default:
			break;
	}
}

@end
