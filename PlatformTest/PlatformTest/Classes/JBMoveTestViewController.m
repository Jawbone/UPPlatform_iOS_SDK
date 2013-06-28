//
//  JBMoveTestViewController.m
//  PlatformTest
//
//  Created by Andy Roth on 5/30/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import "JBMoveTestViewController.h"

#import "UP.h"

@interface JBMoveTestViewController ()

@end

@implementation JBMoveTestViewController

- (void)getMoves
{
    /*
	[UPMoveAPI getMovesWithLimit:14 completion:^(NSArray *results, UPURLResponse *response, NSError *error) {
		[self showResults:results];
	}];
     */
    
    NSDate *endDate = [NSDate date];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[endDate timeIntervalSince1970] - (24 * 60 * 60 * 14)];
    [UPMoveAPI getMovesFromStartDate:startDate toEndDate:endDate completion:^(NSArray *results, UPURLResponse *response, NSError *error) {
        [self showResults:results];
    }];
}

- (void)refreshMove
{
	[UPMoveAPI getMovesWithLimit:1 completion:^(NSArray *results, UPURLResponse *response, NSError *error) {
		if (results.count > 0)
		{
			[UPMoveAPI refreshMove:results[0] completion:^(UPMove *move, UPURLResponse *response, NSError *error) {
				[self showResults:move];
			}];
		}
	}];
}

- (void)getMoveGraphImage
{
	[UPMoveAPI getMovesWithLimit:1 completion:^(NSArray *results, UPURLResponse *response, NSError *error) {
		if (results.count > 0)
		{
			UPMove *move = results[0];
			
			[UPMoveAPI getMoveGraphImage:move completion:^(UIImage *image) {
				UIViewController *blank = [[UIViewController alloc] init];
				[self.navigationController pushViewController:blank animated:YES];
				
				UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
				[blank.view addSubview:imageView];
			}];
		}
	}];
}

- (void)getMoveSnapshot
{
	[UPMoveAPI getMovesWithLimit:1 completion:^(NSArray *results, UPURLResponse *response, NSError *error) {
		if (results.count > 0)
		{
			UPMove *move = results[0];
			
			[UPMoveAPI getMoveSnapshot:move completion:^(UPSnapshot *snapshot, UPURLResponse *response, NSError *error) {
				[self showResults:snapshot];
			}];
		}
	}];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.row)
	{
		case 0:
			[self getMoves];
			break;
			
		case 1:
			[self refreshMove];
			break;
			
		case 2:
			[self getMoveGraphImage];
			break;
			
		case 3:
			[self getMoveSnapshot];
			break;
			
		default:
			break;
	}
}

@end
