//
//  ANTagsView.m
//  ANTagsView
//
//  Created by Adnan Nasir on 27/08/2015.
//  Copyright (c) 2015 Adnan Nasir. All rights reserved.
//

#import "ANTagsView.h"
#define TAG_SPACE_HORIZONTAL 10
#define TAG_SPACE_VERTICAL 5
#define DEFAULT_VIEW_HEIGHT 44
#define MAX_TAG_SIZE 300
#define MIN_TAG_SIZE 40
#define DEFAULT_VIEW_WIDTH 320
#define DEFAULT_TAG_CORNER_RADIUS 10
@implementation ANTagsView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(instancetype) initWithTags:(NSArray *)tagsArray
{
    self = [super init];
    if(self)
    {
        
        viewWidth = DEFAULT_VIEW_WIDTH;
        tagsToDisplay = tagsArray;
        maxTagSize = DEFAULT_VIEW_WIDTH - TAG_SPACE_HORIZONTAL;
        tagRadius = DEFAULT_TAG_CORNER_RADIUS;
        tagTextColor = [UIColor blueColor];
        tagBGColor = [UIColor grayColor];
        [self renderTagsOnView];
        
    }
    return self;
    
}
-(instancetype) initWithTags:(NSArray *)tagsArray frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        
        viewWidth = frame.size.width;
        tagsToDisplay = tagsArray;
        maxTagSize = DEFAULT_VIEW_WIDTH - TAG_SPACE_HORIZONTAL;
        tagRadius = DEFAULT_TAG_CORNER_RADIUS;
        tagTextColor = [UIColor blueColor];
        tagBGColor = [UIColor grayColor];
        [self renderTagsOnView];
        
    }
    return self;
}

-(void) renderTagsOnView
{
    [self removeAllTags];
    
    tagXPos = TAG_SPACE_HORIZONTAL;
    tagYPos = TAG_SPACE_VERTICAL;
    viewHeight = DEFAULT_VIEW_HEIGHT;
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, viewWidth, viewHeight);
    for (NSString *tag in tagsToDisplay)
    {
        [self addTagInView:tag];
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y+10, viewWidth, viewHeight+10);
}
-(void) setTagBackgroundColor:(UIColor *)color
{
    tagBGColor = color;
    for (UIView *view in self.subviews)
    {
        if([view isKindOfClass:[UILabel class]])
        {
            UILabel *tag = (UILabel *)view;
            tag.backgroundColor = tagBGColor;
        }
    }
}

-(void) removeAllTags
{
    
    for (UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
    
}
-(void) setFrameWidth:(int)width;
{
    viewWidth = width;
    maxTagSize = viewWidth - TAG_SPACE_HORIZONTAL;
    [self renderTagsOnView];
    
}

-(void) setTagTextColor:(UIColor *)color
{
    tagTextColor = color;
    for (UIView *view in self.subviews)
    {
        if([view isKindOfClass:[UILabel class]])
        {
            UILabel *tag = (UILabel *)view;
            tag.textColor = tagTextColor;
        }
    }
}

-(void) setTagCornerRadius:(int)radius
{
    tagRadius = radius;
    for (UIView *view in self.subviews)
    {
        if([view isKindOfClass:[UILabel class]])
        {
            UILabel *tag = (UILabel *)view;
            tag.layer.masksToBounds = YES;
            tag.layer.cornerRadius = tagRadius;
        }
    }
}
-(void) addTagInView:(NSString *)tag
{
    UILabel *tagLabel = [[UILabel alloc]init];
    UIFont *tagFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];
    
    CGSize maximumLabelSize = CGSizeMake( maxTagSize, CGRectGetWidth(self.bounds) );
    
    CGSize expectedLabelSize = [tag sizeWithFont:tagFont
                               constrainedToSize:maximumLabelSize
                                   lineBreakMode:[tagLabel lineBreakMode]];
    if(expectedLabelSize.width < MIN_TAG_SIZE)
        expectedLabelSize.width = MIN_TAG_SIZE;
    NSLog(@"%f",expectedLabelSize.width);
    
    if((tagXPos + expectedLabelSize.width) > self.frame.size.width)
    {
        tagXPos = TAG_SPACE_HORIZONTAL;
        tagYPos += expectedLabelSize.height + TAG_SPACE_VERTICAL+6;
        viewHeight += expectedLabelSize.height + TAG_SPACE_HORIZONTAL;
    }
    
    tagLabel.frame = CGRectMake(tagXPos, tagYPos, expectedLabelSize.width+18, expectedLabelSize.height+6);
    tagLabel.text = tag;
    tagLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];
    tagLabel.textAlignment = NSTextAlignmentCenter;
    tagLabel.backgroundColor = tagBGColor;
    tagLabel.textColor = tagTextColor;
    tagLabel.layer.masksToBounds = YES;
    tagLabel.layer.cornerRadius = tagRadius;
    tagLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *pgr = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(getString:)];
    
    [tagLabel addGestureRecognizer:pgr];
    [self addSubview:tagLabel];
    
    tagXPos += tagLabel.frame.size.width + TAG_SPACE_HORIZONTAL;
    
}

- (void)getString:(UITapGestureRecognizer *)sender
{
    UILabel *label = sender.view;
    NSMutableString *word;
    if (_categoryString == nil) {
        word = [[NSMutableString alloc] initWithString:@"                                     "];
    } else {
        word = [[NSMutableString alloc] initWithString:_categoryString];
    }
    if (sender.view.backgroundColor == [UIColor grayColor]) {
        sender.view.backgroundColor = [UIColor colorWithRed:0.396 green:0.803 blue:0.64 alpha:1];
        if ([label.text  isEqual: @"Books"]) {
            NSLog(@"1");
            [word insertString:@"1" atIndex:0];
        }
        if ([label.text  isEqual: @"Business"]) {
            NSLog(@"2");
            [word insertString:@"2" atIndex:1];
        }
        if ([label.text  isEqual: @"Catalogues"]) {
            NSLog(@"3");
            [word insertString:@"3" atIndex:2];
        }
        if ([label.text  isEqual: @"Education"]) {
            NSLog(@"4");
            [word insertString:@"4" atIndex:3];
        }
        if ([label.text  isEqual: @"Finance"]) {
            NSLog(@"5");
            [word insertString:@"5" atIndex:4];
        }
        if ([label.text  isEqual: @"Food & Drink"]) {
            NSLog(@"6");
            [word insertString:@"6" atIndex:5];
        }
        if ([label.text  isEqual: @"Games"]) {
            NSLog(@"7");
            [word insertString:@"7" atIndex:6];
        }
        if ([label.text  isEqual: @"Health & Fitness"]) {
            NSLog(@"8");
            [word insertString:@"8" atIndex:7];
        }
        if ([label.text  isEqual: @"Kids"]) {
            NSLog(@"9");
            [word insertString:@"9" atIndex:8];
        }
        if ([label.text  isEqual: @"Lifestyle"]) {
            NSLog(@"10");
            [word insertString:@"10" atIndex:9];
        }
        if ([label.text  isEqual: @"Medical"]) {
            NSLog(@"11");
            [word insertString:@"11" atIndex:11];
        }
        if ([label.text  isEqual: @"Music"]) {
            NSLog(@"12");
            [word insertString:@"12" atIndex:13];
        }
        if ([label.text  isEqual: @"Navigation"]) {
            NSLog(@"13");
            [word insertString:@"13" atIndex:15];
        }
        if ([label.text  isEqual: @"News"]) {
            NSLog(@"14");
            [word insertString:@"14" atIndex:17];
        }
        if ([label.text  isEqual: @"Magazines & Newspapers"]) {
            NSLog(@"15");
            [word insertString:@"15" atIndex:19];
        }
        if ([label.text  isEqual: @"Photo & Video"]) {
            NSLog(@"16");
            [word insertString:@"16" atIndex:21];
        }
        if ([label.text  isEqual: @"Productivity"]) {
            NSLog(@"17");
            [word insertString:@"17" atIndex:23];
        }
        if ([label.text  isEqual: @"Reference"]) {
            NSLog(@"18");
            [word insertString:@"18" atIndex:25];
        }
        if ([label.text  isEqual: @"Shopping"]) {
            NSLog(@"19");
            [word insertString:@"19" atIndex:27];
        }
        if ([label.text  isEqual: @"Social Networking"]) {
            NSLog(@"20");
            [word insertString:@"20" atIndex:29];
        }
        if ([label.text  isEqual: @"Sports"]) {
            NSLog(@"21");
            [word insertString:@"21" atIndex:31];
        }
        if ([label.text  isEqual: @"Travel"]) {
            NSLog(@"22");
            [word insertString:@"22" atIndex:33];
        }
        if ([label.text  isEqual: @"Utilities"]) {
            NSLog(@"23");
            [word insertString:@"23" atIndex:35];
        }
        if ([label.text  isEqual: @"Weather"]) {
            NSLog(@"24");
            [word insertString:@"24" atIndex:37];
        }

    } else {
        sender.view.backgroundColor = [UIColor grayColor];
        UILabel *label = sender.view;
        if ([label.text  isEqual: @"Books"]) {
            NSLog(@"1");
            [word insertString:@" " atIndex:0];
        }
        if ([label.text  isEqual: @"Business"]) {
            NSLog(@"2");
            [word insertString:@" " atIndex:1];
        }
        if ([label.text  isEqual: @"Catalogues"]) {
            NSLog(@"3");
            [word insertString:@" " atIndex:2];
        }
        if ([label.text  isEqual: @"Education"]) {
            NSLog(@"4");
            [word insertString:@" " atIndex:3];
        }
        if ([label.text  isEqual: @"Finance"]) {
            NSLog(@"5");
            [word insertString:@" " atIndex:4];
        }
        if ([label.text  isEqual: @"Food & Drink"]) {
            NSLog(@"6");
            [word insertString:@" " atIndex:5];
        }
        if ([label.text  isEqual: @"Games"]) {
            NSLog(@"7");
            [word insertString:@" " atIndex:6];
        }
        if ([label.text  isEqual: @"Health & Fitness"]) {
            NSLog(@"8");
            [word insertString:@" " atIndex:7];
        }
        if ([label.text  isEqual: @"Kids"]) {
            NSLog(@"9");
            [word insertString:@" " atIndex:8];
        }
        if ([label.text  isEqual: @"Lifestyle"]) {
            NSLog(@"10");
            [word insertString:@"  " atIndex:9];
        }
        if ([label.text  isEqual: @"Medical"]) {
            NSLog(@"11");
            [word insertString:@"  " atIndex:11];
        }
        if ([label.text  isEqual: @"Music"]) {
            NSLog(@"12");
            [word insertString:@"  " atIndex:13];
        }
        if ([label.text  isEqual: @"Navigation"]) {
            NSLog(@"13");
            [word insertString:@"  " atIndex:15];
        }
        if ([label.text  isEqual: @"News"]) {
            NSLog(@"14");
            [word insertString:@"  " atIndex:17];
        }
        if ([label.text  isEqual: @"Magazines & Newspapers"]) {
            NSLog(@"15");
            [word insertString:@"  " atIndex:19];
        }
        if ([label.text  isEqual: @"Photo & Video"]) {
            NSLog(@"16");
            [word insertString:@"  " atIndex:21];
        }
        if ([label.text  isEqual: @"Productivity"]) {
            NSLog(@"17");
            [word insertString:@"  " atIndex:23];
        }
        if ([label.text  isEqual: @"Reference"]) {
            NSLog(@"18");
            [word insertString:@"  " atIndex:25];
        }
        if ([label.text  isEqual: @"Shopping"]) {
            NSLog(@"19");
            [word insertString:@"  " atIndex:27];
        }
        if ([label.text  isEqual: @"Social Networking"]) {
            NSLog(@"20");
            [word insertString:@"  " atIndex:29];
        }
        if ([label.text  isEqual: @"Sports"]) {
            NSLog(@"21");
            [word insertString:@"  " atIndex:31];
        }
        if ([label.text  isEqual: @"Travel"]) {
            NSLog(@"22");
            [word insertString:@"  " atIndex:33];
        }
        if ([label.text  isEqual: @"Utilities"]) {
            NSLog(@"23");
            [word insertString:@"  " atIndex:35];
        }
        if ([label.text  isEqual: @"Weather"]) {
            NSLog(@"24");
            [word insertString:@"  " atIndex:37];
        }

    }
    self.categoryString = word;
    [self.delegate stringFromSubview:word];
}

-(void)handlePan:(UITapGestureRecognizer *)sender{
    if (sender.view.backgroundColor == [UIColor grayColor]) {
        sender.view.backgroundColor = [UIColor colorWithRed:0.396 green:0.803 blue:0.64 alpha:1];
    } else {
        sender.view.backgroundColor = [UIColor grayColor];
    }
    UILabel *label = sender.view;
    NSMutableString *word = [[NSMutableString alloc] initWithString:@"                                     "];
    if ([label.text  isEqual: @"Books"]) {
        NSLog(@"1");
        [word insertString:@"1" atIndex:0];
    }
    if ([label.text  isEqual: @"Business"]) {
        NSLog(@"2");
        [word insertString:@"2" atIndex:1];
    }
    if ([label.text  isEqual: @"Catalogues"]) {
        NSLog(@"3");
        [word insertString:@"3" atIndex:2];
    }
    if ([label.text  isEqual: @"Education"]) {
        NSLog(@"4");
        [word insertString:@"4" atIndex:3];
    }
    if ([label.text  isEqual: @"Finance"]) {
        NSLog(@"5");
        [word insertString:@"5" atIndex:4];
    }
    if ([label.text  isEqual: @"Food & Drink"]) {
        NSLog(@"6");
        [word insertString:@"6" atIndex:5];
    }
    if ([label.text  isEqual: @"Games"]) {
        NSLog(@"7");
        [word insertString:@"7" atIndex:6];
    }
    if ([label.text  isEqual: @"Health & Fitness"]) {
        NSLog(@"8");
        [word insertString:@"8" atIndex:7];
    }
    if ([label.text  isEqual: @"Kids"]) {
        NSLog(@"9");
        [word insertString:@"9" atIndex:8];
    }
    if ([label.text  isEqual: @"Lifestyle"]) {
        NSLog(@"10");
        [word insertString:@"10" atIndex:9];
    }
    if ([label.text  isEqual: @"Medical"]) {
        NSLog(@"11");
        [word insertString:@"11" atIndex:11];
    }
    if ([label.text  isEqual: @"Music"]) {
        NSLog(@"12");
        [word insertString:@"12" atIndex:13];
    }
    if ([label.text  isEqual: @"Navigation"]) {
        NSLog(@"13");
        [word insertString:@"13" atIndex:15];
    }
    if ([label.text  isEqual: @"News"]) {
        NSLog(@"14");
        [word insertString:@"14" atIndex:17];
    }
    if ([label.text  isEqual: @"Magazines & Newspapers"]) {
        NSLog(@"15");
        [word insertString:@"15" atIndex:19];
    }
    if ([label.text  isEqual: @"Photo & Video"]) {
        NSLog(@"16");
        [word insertString:@"16" atIndex:21];
    }
    if ([label.text  isEqual: @"Productivity"]) {
        NSLog(@"17");
        [word insertString:@"17" atIndex:23];
    }
    if ([label.text  isEqual: @"Reference"]) {
        NSLog(@"18");
        [word insertString:@"18" atIndex:25];
    }
    if ([label.text  isEqual: @"Shopping"]) {
        NSLog(@"19");
        [word insertString:@"19" atIndex:27];
    }
    if ([label.text  isEqual: @"Social Networking"]) {
        NSLog(@"20");
        [word insertString:@"20" atIndex:29];
    }
    if ([label.text  isEqual: @"Sports"]) {
        NSLog(@"21");
        [word insertString:@"21" atIndex:31];
    }
    if ([label.text  isEqual: @"Travel"]) {
        NSLog(@"22");
        [word insertString:@"22" atIndex:33];
    }
    if ([label.text  isEqual: @"Utilities"]) {
        NSLog(@"23");
        [word insertString:@"23" atIndex:35];
    }
    if ([label.text  isEqual: @"Weather"]) {
        NSLog(@"24");
        [word insertString:@"24" atIndex:37];
    }
}

@end
