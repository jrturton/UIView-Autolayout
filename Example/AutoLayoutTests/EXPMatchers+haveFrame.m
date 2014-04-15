//
//  EXPMatchers+haveConstraint.m
//  AutoLayoutDemo
//
//  Created by James Frost on 10/08/2013.
//  Copyright (c) 2013 James Frost. All rights reserved.
//

#import "EXPMatchers+haveFrame.h"
#import <CoreGraphics/CoreGraphics.h>

EXPMatcherImplementationBegin(haveFrame, (CGRect expected)) {
    BOOL actualIsNil = (actual == nil);
    BOOL expectedIsNull = CGRectIsNull(expected);

    prerequisite(^BOOL{
        return !(actualIsNil || expectedIsNull);
        // Return `NO` if matcher should fail whether or not the result is inverted using `.Not`.
    });
    
    match(^BOOL{
        CGRect frame = [(UIView *)actual frame];
        
        return CGRectEqualToRect(frame, expected);
    });
    
    failureMessageForTo(^NSString *{
        if(actualIsNil) return @"the actual view is nil/null";
        if(expectedIsNull) return @"the expected frame is nil/null";
        return [NSString stringWithFormat:@"expected: view to have a frame %@, "
                "got: a view with frame %@, which does not match frame %@",
                NSStringFromCGRect(expected), NSStringFromCGRect(((UIView *)actual).frame), NSStringFromCGRect(expected)];
    });
    
    failureMessageForNotTo(^NSString *{
        if(actualIsNil) return @"the actual view is nil/null";
        if(expectedIsNull) return @"the expected frame is nil/null";
        return [NSString stringWithFormat:@"expected: view not to have a frame %@, "
                "got: a view with frame %@, which matches frame %@",
                NSStringFromCGRect(expected), NSStringFromCGRect(((UIView *)actual).frame), NSStringFromCGRect(expected)];
    });
}
EXPMatcherImplementationEnd