//
//  JBBandEventTestViewController.m
//  APIExplorer
//
//  Created by Andy Roth on 3/31/14.
//  Copyright (c) 2014 Jawbone. All rights reserved.
//

#import "JBBandEventTestViewController.h"

#import "UP.h"

@interface JBBandEventTestViewController ()

@end

@implementation JBBandEventTestViewController

- (void)getBandEvents
{
    NSDate *endDate = [NSDate date];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[endDate timeIntervalSince1970] - (24 * 60 * 60 * 100)];
    
    [UPBandEventAPI getBandEventsFromStartDate:startDate toEndDate:endDate completion:^(NSArray *results, UPURLResponse *response, NSError *error) {
        [self showResults:results];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.row)
	{
		case 0:
			[self getBandEvents];
			break;
			
		default:
			break;
	}
}

@end
