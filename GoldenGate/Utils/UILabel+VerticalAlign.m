//
//  UILabel+Extension.m
//  DnBNOR
//
//  Created by Andreas Petrov on 10/18/11.
//  Copyright 2011 Reaktor Magma AS. All rights reserved.
//  Source http://stackoverflow.com/questions/1054558/how-do-i-vertically-align-text-within-a-uilabel/3676733#3676733
//

@implementation UILabel (VerticalAlign)

- (void)alignTop
{
    CGSize fontSize = [self.text sizeWithFont:self.font];
    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth = self.frame.size.width;    //expected width of label
    
    CGSize theStringSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
    int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
    
    for(int i=0; i<newLinesToPad; i++)
    {
        self.text = [self.text stringByAppendingString:@"\n "];
    }
}

- (void)alignBottom
{
    CGSize fontSize = [self.text sizeWithFont:self.font];
    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth = self.frame.size.width;    //expected width of label
    
    CGSize theStringSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
    int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;

    for(int i=0; i<newLinesToPad; i++)
    {
        self.text = [NSString stringWithFormat:@" \n%@",self.text];
    }
}

@end