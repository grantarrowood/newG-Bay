//
//  TagGroups.m
//  AutomaticHeightTagTableViewCell
//
//  Created by WEI-JEN TU on 2016-07-16.
//  Copyright © 2016 Cold Yam. All rights reserved.
//

#import "TagGroups.h"

@implementation TagGroups

+ (NSArray<NSArray<AHTag *> *> *)dataSource: (NSMutableString *)arrayItems {
    NSString *newString = [arrayItems substringWithRange:NSMakeRange(0, 1)];
    NSArray *array = [NSArray arrayWithObjects:nil];
    if (([arrayItems length] > 0) && ([newString  isEqual: @"1"])) {
        array = [array arrayByAddingObject:[self app1]];
        [arrayItems deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    newString = [arrayItems substringWithRange:NSMakeRange(0, 1)];
    if (([arrayItems length] > 0) && ([newString  isEqual: @"2"])) {
        array = [array arrayByAddingObject:[self app2]];
        if ([arrayItems length] > 1) {
            [arrayItems deleteCharactersInRange:NSMakeRange(0, 1)];
        }
    }
    newString = [arrayItems substringWithRange:NSMakeRange(0, 1)];
    if (([arrayItems length] > 0) && ([newString  isEqual: @"3"])) {
        array = [array arrayByAddingObject:[self app3]];
        if ([arrayItems length] > 1) {
            [arrayItems deleteCharactersInRange:NSMakeRange(0, 1)];
        }
    }
    newString = [arrayItems substringWithRange:NSMakeRange(0, 1)];
    if (([arrayItems length] > 0) && ([newString  isEqual: @"4"])) {
        array = [array arrayByAddingObject:[self app4]];
        if ([arrayItems length] > 1) {
            [arrayItems deleteCharactersInRange:NSMakeRange(0, 1)];
        }
    }
    newString = [arrayItems substringWithRange:NSMakeRange(0, 1)];
    if (([arrayItems length] > 0) && ([newString  isEqual: @"5"])) {
        array = [array arrayByAddingObject:[self app5]];
        if ([arrayItems length] > 1) {
            [arrayItems deleteCharactersInRange:NSMakeRange(0, 1)];
        }
    }
    newString = [arrayItems substringWithRange:NSMakeRange(0, 1)];
    if (([arrayItems length] > 0) && ([newString  isEqual: @"6"])) {
        array = [array arrayByAddingObject:[self app6]];
        if ([arrayItems length] > 1) {
            [arrayItems deleteCharactersInRange:NSMakeRange(0, 1)];
        }
    }
    newString = [arrayItems substringWithRange:NSMakeRange(0, 1)];
    if (([arrayItems length] > 0) && ([newString  isEqual: @"7"])) {
        array = [array arrayByAddingObject:[self app7]];
        if ([arrayItems length] > 1) {
            [arrayItems deleteCharactersInRange:NSMakeRange(0, 1)];
        }
    }
    newString = [arrayItems substringWithRange:NSMakeRange(0, 1)];
    if (([arrayItems length] > 0) && ([newString  isEqual: @"8"])) {
        array = [array arrayByAddingObject:[self app8]];
        [arrayItems deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    newString = [arrayItems substringWithRange:NSMakeRange(0, 1)];
    if (([arrayItems length] > 0) && ([newString  isEqual: @"9"])) {
        array = [array arrayByAddingObject:[self app9]];
        if ([arrayItems length] > 1) {
            [arrayItems deleteCharactersInRange:NSMakeRange(0, 1)];
        }
    }
    if ([arrayItems length] > 1) {
        newString = [arrayItems substringWithRange:NSMakeRange(0, 2)];
        if (([arrayItems length] > 0) && ([newString  isEqual: @"10"])) {
            array = [array arrayByAddingObject:[self app10]];
            if ([arrayItems length] > 2) {
                [arrayItems deleteCharactersInRange:NSMakeRange(0, 2)];
            }
        }
        newString = [arrayItems substringWithRange:NSMakeRange(0, 2)];
        if (([arrayItems length] > 0) && ([newString  isEqual: @"11"])) {
            array = [array arrayByAddingObject:[self app11]];
            if ([arrayItems length] > 2) {
                [arrayItems deleteCharactersInRange:NSMakeRange(0, 2)];
            }
        }
        newString = [arrayItems substringWithRange:NSMakeRange(0, 2)];
        if (([arrayItems length] > 0) && ([newString  isEqual: @"12"])) {
            array = [array arrayByAddingObject:[self app12]];
            if ([arrayItems length] > 2) {
                [arrayItems deleteCharactersInRange:NSMakeRange(0, 2)];
            }
        }
        newString = [arrayItems substringWithRange:NSMakeRange(0, 2)];
        if (([arrayItems length] > 0) && ([newString  isEqual: @"13"])) {
            array = [array arrayByAddingObject:[self app13]];
            if ([arrayItems length] > 2) {
                [arrayItems deleteCharactersInRange:NSMakeRange(0, 2)];
            }
        }
        newString = [arrayItems substringWithRange:NSMakeRange(0, 2)];
        if (([arrayItems length] > 0) && ([newString  isEqual: @"14"])) {
            array = [array arrayByAddingObject:[self app14]];
            if ([arrayItems length] > 2) {
                [arrayItems deleteCharactersInRange:NSMakeRange(0, 2)];
            }
        }
        newString = [arrayItems substringWithRange:NSMakeRange(0, 2)];
        if (([arrayItems length] > 0) && ([newString  isEqual: @"15"])) {
            array = [array arrayByAddingObject:[self app15]];
            if ([arrayItems length] > 1) {
                [arrayItems deleteCharactersInRange:NSMakeRange(0, 2)];
            }
        }
        newString = [arrayItems substringWithRange:NSMakeRange(0, 2)];
        if (([arrayItems length] > 0) && ([newString  isEqual: @"16"])) {
            array = [array arrayByAddingObject:[self app16]];
            if ([arrayItems length] > 1) {
                [arrayItems deleteCharactersInRange:NSMakeRange(0, 2)];
            }
        }
        newString = [arrayItems substringWithRange:NSMakeRange(0, 2)];
        if (([arrayItems length] > 0) && ([newString  isEqual: @"17"])) {
            if ([arrayItems length] > 1) {
                [arrayItems deleteCharactersInRange:NSMakeRange(0, 2)];
            }
        }
        newString = [arrayItems substringWithRange:NSMakeRange(0, 2)];
        if (([arrayItems length] > 0) && ([newString  isEqual: @"18"])) {
            array = [array arrayByAddingObject:[self app18]];
            if ([arrayItems length] > 1) {
                [arrayItems deleteCharactersInRange:NSMakeRange(0, 2)];
            }
        }
        newString = [arrayItems substringWithRange:NSMakeRange(0, 2)];
        if (([arrayItems length] > 0) && ([newString  isEqual: @"19"])) {
            array = [array arrayByAddingObject:[self app19]];
            if ([arrayItems length] > 1) {
                [arrayItems deleteCharactersInRange:NSMakeRange(0, 2)];
            }
        }
        newString = [arrayItems substringWithRange:NSMakeRange(0, 2)];
        if (([arrayItems length] > 0) && ([newString  isEqual: @"20"])) {
            array = [array arrayByAddingObject:[self app20]];
            if ([arrayItems length] > 1) {
                [arrayItems deleteCharactersInRange:NSMakeRange(0, 2)];
            }
        }
        newString = [arrayItems substringWithRange:NSMakeRange(0, 2)];
        if (([arrayItems length] > 0) && ([newString  isEqual: @"21"])) {
            array = [array arrayByAddingObject:[self app21]];
            if ([arrayItems length] > 1) {
                [arrayItems deleteCharactersInRange:NSMakeRange(0, 2)];
            }
        }
        newString = [arrayItems substringWithRange:NSMakeRange(0, 2)];
        if (([arrayItems length] > 0) && ([newString  isEqual: @"22"])) {
            array = [array arrayByAddingObject:[self app22]];
            if ([arrayItems length] > 1) {
                [arrayItems deleteCharactersInRange:NSMakeRange(0, 2)];
            }
        }
        newString = [arrayItems substringWithRange:NSMakeRange(0, 2)];
        if (([arrayItems length] > 0) && ([newString  isEqual: @"23"])) {
            array = [array arrayByAddingObject:[self app23]];
            if ([arrayItems length] > 1) {
                [arrayItems deleteCharactersInRange:NSMakeRange(0, 2)];
            }
        }
        newString = [arrayItems substringWithRange:NSMakeRange(0, 2)];
        if (([arrayItems length] > 0) && ([newString  isEqual: @"24"])) {
            array = [array arrayByAddingObject:[self app24]];
            if ([arrayItems length] > 1) {
                [arrayItems deleteCharactersInRange:NSMakeRange(0, 2)];
            }
        }
    }
        //NSArray *app = @[[self app1], [self app2], [self app3], [self app4], [self app5], [self app6], [self app7], [self app8], [self app9], [self app10], [self app11], [self app12], [self app13], [self app14], [self app15], [self app16], [self app17], [self app18], [self app19], [self app20], [self app22], [self app22], [self app23], [self app24]];
    return @[array];
}


#pragma mark - App store

+ (AHTag *)app1 {
    AHTag *tag = [AHTag new];
    tag.category = @"App Store";
    tag.title = @"Books";
    tag.color = [UIColor colorWithRed:0.396 green:0.803 blue:0.64 alpha:1];
    tag.url = [NSURL URLWithString:@"http://appstore.com"];
    tag.enabled = @YES;
    return tag;
}

+ (AHTag *)app2 {
    AHTag *tag = [AHTag new];
    tag.category = @"App Store";
    tag.title = @"Business";
    tag.color = [UIColor colorWithRed:0.396 green:0.803 blue:0.64 alpha:1];
    tag.url = [NSURL URLWithString:@"http://appstore.com"];
    tag.enabled = @YES;
    return tag;
}

+ (AHTag *)app3 {
    AHTag *tag = [AHTag new];
    tag.category = @"App Store";
    tag.title = @"Catalogues";
    tag.color = [UIColor colorWithRed:0.396 green:0.803 blue:0.64 alpha:1];
    tag.url = [NSURL URLWithString:@"http://appstore.com"];
    tag.enabled = @YES;
    return tag;
}

+ (AHTag *)app4 {
    AHTag *tag = [AHTag new];
    tag.category = @"App Store";
    tag.title = @"Education";
    tag.color = [UIColor colorWithRed:0.396 green:0.803 blue:0.64 alpha:1];
    tag.url = [NSURL URLWithString:@"http://appstore.com"];
    tag.enabled = @YES;
    return tag;
}

+ (AHTag *)app5 {
    AHTag *tag = [AHTag new];
    tag.category = @"App Store";
    tag.title = @"Finance";
    tag.color = [UIColor colorWithRed:0.396 green:0.803 blue:0.64 alpha:1];
    tag.url = [NSURL URLWithString:@"http://appstore.com"];
    tag.enabled = @YES;
    return tag;
}

+ (AHTag *)app6 {
    AHTag *tag = [AHTag new];
    tag.category = @"App Store";
    tag.title = @"Food & Drink";
    tag.color = [UIColor colorWithRed:0.396 green:0.803 blue:0.64 alpha:1];
    tag.url = [NSURL URLWithString:@"http://appstore.com"];
    tag.enabled = @YES;
    return tag;
}

+ (AHTag *)app7 {
    AHTag *tag = [AHTag new];
    tag.category = @"App Store";
    tag.title = @"Games";
    tag.color = [UIColor colorWithRed:0.396 green:0.803 blue:0.64 alpha:1];
    tag.url = [NSURL URLWithString:@"http://appstore.com"];
    tag.enabled = @YES;
    return tag;
}

+ (AHTag *)app8 {
    AHTag *tag = [AHTag new];
    tag.category = @"App Store";
    tag.title = @"Health & Fitness";
    tag.color = [UIColor colorWithRed:0.396 green:0.803 blue:0.64 alpha:1];
    tag.url = [NSURL URLWithString:@"http://appstore.com"];
    tag.enabled = @YES;
    return tag;
}

+ (AHTag *)app9 {
    AHTag *tag = [AHTag new];
    tag.category = @"App Store";
    tag.title = @"Kids";
    tag.color = [UIColor colorWithRed:0.396 green:0.803 blue:0.64 alpha:1];
    tag.url = [NSURL URLWithString:@"http://appstore.com"];
    tag.enabled = @YES;
    return tag;
}

+ (AHTag *)app10 {
    AHTag *tag = [AHTag new];
    tag.category = @"App Store";
    tag.title = @"Lifestyle";
    tag.color = [UIColor colorWithRed:0.396 green:0.803 blue:0.64 alpha:1];
    tag.url = [NSURL URLWithString:@"http://appstore.com"];
    tag.enabled = @YES;
    return tag;
}

+ (AHTag *)app11 {
    AHTag *tag = [AHTag new];
    tag.category = @"App Store";
    tag.title = @"Medical";
    tag.color = [UIColor colorWithRed:0.396 green:0.803 blue:0.64 alpha:1];
    tag.url = [NSURL URLWithString:@"http://appstore.com"];
    tag.enabled = @YES;
    return tag;
}

+ (AHTag *)app12 {
    AHTag *tag = [AHTag new];
    tag.category = @"App Store";
    tag.title = @"Music";
    tag.color = [UIColor colorWithRed:0.396 green:0.803 blue:0.64 alpha:1];
    tag.url = [NSURL URLWithString:@"http://appstore.com"];
    tag.enabled = @YES;
    return tag;
}

+ (AHTag *)app13 {
    AHTag *tag = [AHTag new];
    tag.category = @"App Store";
    tag.title = @"Navigation";
    tag.color = [UIColor colorWithRed:0.396 green:0.803 blue:0.64 alpha:1];
    tag.url = [NSURL URLWithString:@"http://appstore.com"];
    tag.enabled = @YES;
    return tag;
}

+ (AHTag *)app14 {
    AHTag *tag = [AHTag new];
    tag.category = @"App Store";
    tag.title = @"News";
    tag.color = [UIColor colorWithRed:0.396 green:0.803 blue:0.64 alpha:1];
    tag.url = [NSURL URLWithString:@"http://appstore.com"];
    tag.enabled = @YES;
    return tag;
}

+ (AHTag *)app15 {
    AHTag *tag = [AHTag new];
    tag.category = @"App Store";
    tag.title = @"Magazines & Newspapers";
    tag.color = [UIColor colorWithRed:0.396 green:0.803 blue:0.64 alpha:1];
    tag.url = [NSURL URLWithString:@"http://appstore.com"];
    tag.enabled = @YES;
    return tag;
}

+ (AHTag *)app16 {
    AHTag *tag = [AHTag new];
    tag.category = @"App Store";
    tag.title = @"Photo & Video";
    tag.color = [UIColor colorWithRed:0.396 green:0.803 blue:0.64 alpha:1];
    tag.url = [NSURL URLWithString:@"http://appstore.com"];
    tag.enabled = @YES;
    return tag;
}

+ (AHTag *)app17 {
    AHTag *tag = [AHTag new];
    tag.category = @"App Store";
    tag.title = @"Productivity";
    tag.color = [UIColor colorWithRed:0.396 green:0.803 blue:0.64 alpha:1];
    tag.url = [NSURL URLWithString:@"http://appstore.com"];
    tag.enabled = @YES;
    return tag;
}

+ (AHTag *)app18 {
    AHTag *tag = [AHTag new];
    tag.category = @"App Store";
    tag.title = @"Reference";
    tag.color = [UIColor colorWithRed:0.396 green:0.803 blue:0.64 alpha:1];
    tag.url = [NSURL URLWithString:@"http://appstore.com"];
    tag.enabled = @YES;
    return tag;
}

+ (AHTag *)app19 {
    AHTag *tag = [AHTag new];
    tag.category = @"App Store";
    tag.title = @"Shopping";
    tag.color = [UIColor colorWithRed:0.396 green:0.803 blue:0.64 alpha:1];
    tag.url = [NSURL URLWithString:@"http://appstore.com"];
    tag.enabled = @YES;
    return tag;
}

+ (AHTag *)app20 {
    AHTag *tag = [AHTag new];
    tag.category = @"App Store";
    tag.title = @"Social Networking";
    tag.color = [UIColor colorWithRed:0.396 green:0.803 blue:0.64 alpha:1];
    tag.url = [NSURL URLWithString:@"http://appstore.com"];
    tag.enabled = @YES;
    return tag;
}

+ (AHTag *)app21 {
    AHTag *tag = [AHTag new];
    tag.category = @"App Store";
    tag.title = @"Sports";
    tag.color = [UIColor colorWithRed:0.396 green:0.803 blue:0.64 alpha:1];
    tag.url = [NSURL URLWithString:@"http://appstore.com"];
    tag.enabled = @YES;
    return tag;
}

+ (AHTag *)app22 {
    AHTag *tag = [AHTag new];
    tag.category = @"App Store";
    tag.title = @"Travel";
    tag.color = [UIColor colorWithRed:0.396 green:0.803 blue:0.64 alpha:1];
    tag.url = [NSURL URLWithString:@"http://appstore.com"];
    tag.enabled = @YES;
    return tag;
}

+ (AHTag *)app23 {
    AHTag *tag = [AHTag new];
    tag.category = @"App Store";
    tag.title = @"Utilities";
    tag.color = [UIColor colorWithRed:0.396 green:0.803 blue:0.64 alpha:1];
    tag.url = [NSURL URLWithString:@"http://appstore.com"];
    tag.enabled = @YES;
    return tag;
}

+ (AHTag *)app24 {
    AHTag *tag = [AHTag new];
    tag.category = @"App Store";
    tag.title = @"Weather";
    tag.color = [UIColor colorWithRed:0.396 green:0.803 blue:0.64 alpha:1];
    tag.url = [NSURL URLWithString:@"http://appstore.com"];
    tag.enabled = @YES;
    return tag;
}

@end
