//
//  INSStackFormViewTextViewElement.m
//  INSStackViewForms
//
//  Created by Michal Zaborowski on 08.01.2016.
//  Copyright © 2016 Michal Zaborowski. All rights reserved.
//

#import "INSStackFormViewTextViewElement.h"

@interface INSStackFormViewTextViewElement () <UITextViewDelegate>
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSMutableArray *additionalConstraints;
@end

@implementation INSStackFormViewTextViewElement

- (void)dealloc {
    [self.textLabel removeObserver:self forKeyPath:@"text"];
}

- (void)setAccessoryView:(UIView *)accessoryView {
    [super setAccessoryView:accessoryView];
    [self.contentView setNeedsUpdateConstraints];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0f];
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;

        self.textView=[[UITextView alloc] initWithFrame:CGRectZero];
        self.textView.frame = CGRectMake(100, 5, 255, 120);
        self.textView.backgroundColor = [UIColor whiteColor];
        self.textView.delegate = self;
        self.textView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f];
        self.textView.editable = YES;
        self.textView.translatesAutoresizingMaskIntoConstraints = YES;
    }
    return self;
}

- (void)configure {
    [super configure];
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.textView];
    [self.contentView addConstraints:[self layoutConstraints]];
    [self.textLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:0];
    self.textLabel.text = self.item.title;
    self.textView.text = self.item.subtitle;
    self.textView.delegate = self;
}


#pragma mark - LayoutConstraints

- (NSArray *)layoutConstraints {
    NSMutableArray * result = [[NSMutableArray alloc] init];
    [self.textLabel setContentHuggingPriority:500 forAxis:UILayoutConstraintAxisHorizontal];
    [self.textLabel setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
    
    // Add Constraints
    //[result addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=11)-[_textView]-(>=11)-|" options:NSLayoutFormatAlignAllBaseline metrics:nil views:NSDictionaryOfVariableBindings(_textView)]];
    [result addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=11)-[_textLabel]-(>=11)-|" options:NSLayoutFormatAlignAllBaseline metrics:nil views:NSDictionaryOfVariableBindings(_textLabel)]];
    
//    [result addObject:[NSLayoutConstraint constraintWithItem:self.textView
//                                                   attribute:NSLayoutAttributeCenterY
//                                                   relatedBy:NSLayoutRelationEqual
//                                                      toItem:self.contentView
//                                                   attribute:NSLayoutAttributeCenterY
//                                                  multiplier:1.f constant:0.f]];
    
    [result addObject:[NSLayoutConstraint constraintWithItem:self.textLabel
                                                   attribute:NSLayoutAttributeCenterY
                                                   relatedBy:NSLayoutRelationEqual
                                                      toItem:self.contentView
                                                   attribute:NSLayoutAttributeCenterY
                                                  multiplier:1.f constant:0.f]];
    
    return result;
}

- (void)updateConstraints {
    if (self.additionalConstraints){
        [self.contentView removeConstraints:self.additionalConstraints];
    }
    NSDictionary *views = @{@"label": self.textLabel, @"textView": self.textView};
    NSDictionary *metrics = @{@"width": self.accessoryView ? @0 : @8};
    
    if (self.textLabel.text.length > 0) {
        self.additionalConstraints = [NSMutableArray arrayWithArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[label]-[textView]-width-|" options:0 metrics:metrics views:views]];
    } else {
        self.additionalConstraints = [NSMutableArray arrayWithArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[textView]-width-|" options:0 metrics:metrics views:views]];
    }
    
    [self.additionalConstraints addObject:[NSLayoutConstraint constraintWithItem:_textView
                                                                          attribute:NSLayoutAttributeWidth
                                                                          relatedBy:self.textFieldLengthPercentage ? NSLayoutRelationEqual : NSLayoutRelationGreaterThanOrEqual
                                                                             toItem:self.contentView
                                                                          attribute:NSLayoutAttributeWidth
                                                                         multiplier:self.textFieldLengthPercentage ? [self.textFieldLengthPercentage floatValue] : 0.3
                                                                           constant:0.0]];
    
    [self.contentView addConstraints:self.additionalConstraints];
    [super updateConstraints];
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ((object == self.textLabel && [keyPath isEqualToString:@"text"])){
        if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeSetting)]){
            [self.contentView setNeedsUpdateConstraints];
        }
    }
}

#pragma mark - Helper

- (void)textViewDidChange:(UITextView *)textView {
    if([self.textView.text length] > 0) {
        self.item.value = self.textView.text;
    } else {
        self.item.value = nil;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    textView.text = nil;
    textView.textColor = [UIColor blackColor];
    return YES;
}


@end
