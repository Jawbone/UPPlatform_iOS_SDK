//
//  JBMoodTestViewController.m
//  APIExplorer
//
//  Created by Andy Roth on 5/30/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import "JBMoodTestViewController.h"

#import "UP.h"

@interface JBMoodTestViewController ()

@end

@implementation JBMoodTestViewController

- (void)postMood
{
	UPMood *newMood = [UPMood moodWithType:UPMoodTypePumpedUp title:@"I'm pumped!"];
	[UPMoodAPI postMood:newMood completion:^(UPMood *mood, UPURLResponse *response, NSError *error) {
		[self showResults:mood];
	}];
}

- (void)getMood
{
	[UPMoodAPI getCurrentMoodWithCompletion:^(UPMood *mood, UPURLResponse *response, NSError *error) {
		[self showResults:mood];
	}];
}

- (void)deleteMood
{
	[UPMoodAPI getCurrentMoodWithCompletion:^(UPMood *mood, UPURLResponse *response, NSError *error) {
		if (mood != nil)
		{
			[UPMoodAPI deleteMood:mood completion:^(id result, UPURLResponse *response, NSError *error) {
				[self showResults:response.metadata];
			}];
		}
	}];
}

- (void)refreshMood
{
	[UPMoodAPI getCurrentMoodWithCompletion:^(UPMood *mood, UPURLResponse *response, NSError *error) {
		if (mood != nil)
		{
			[UPMoodAPI refreshMood:mood completion:^(UPMood *mood, UPURLResponse *response, NSError *error) {
				[self showResults:mood];
			}];
		}
	}];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.row)
	{
		case 0:
			[self postMood];
			break;
			
		case 1:
			[self getMood];
			break;
			
		case 2:
			[self deleteMood];
			break;
			
		case 3:
			[self refreshMood];
			break;
			
		default:
			break;
	}
}

@end
