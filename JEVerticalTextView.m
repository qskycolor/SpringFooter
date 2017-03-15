//
//  JEVerticalTextView.m
//  JiaeD2C
//
//  Created by gaojuyan on 16/5/12.
//  Copyright © 2016年 www.jiae.com. All rights reserved.
//

#import "JEVerticalTextView.h"

@implementation JEVerticalTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = JEBackgroundColor;
    }
    return self;
}

- (float) kerningForCharacter:(NSString *)currentCharacter afterCharacter:(NSString *)previousCharacter
{
    float totalSize = [[NSString stringWithFormat:@"%@%@", previousCharacter, currentCharacter] sizeWithAttributes:self.textAttributes].width;
    float currentCharacterSize = [currentCharacter sizeWithAttributes:self.textAttributes].width;
    float previousCharacterSize = [previousCharacter sizeWithAttributes:self.textAttributes].width;
    
    return (currentCharacterSize + previousCharacterSize) - totalSize;
}

- (void)drawRect:(CGRect)rect {
    //Set drawing context.
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGSize textStringSize = [self.text sizeWithAttributes:self.textAttributes];
    CGFloat characterPosition = (self.height - textStringSize.width - self.text.length) * .5;
    NSString *lastCharacter;

    //Loop thru characters of string.
    for (NSInteger charIdx = 0; charIdx < self.text.length; charIdx++) {

         //Set current character.
         // NSString *currentCharacter = [NSString stringWithFormat:@"%c", [self.text characterAtIndex:charIdx]];
         NSString * currentCharacter = [self.text substringWithRange:NSMakeRange(charIdx, 1)];
         
         //Set currenct character size & kerning.
         CGSize stringSize = [currentCharacter sizeWithAttributes:self.textAttributes];
         float kerning = (lastCharacter) ? [self kerningForCharacter:currentCharacter afterCharacter:lastCharacter] : 0;
         
         //Add half of character width to characterPosition, substract kerning.
         characterPosition += stringSize.height - kerning;
         
         //Calculate character drawing point.
         CGPoint characterPoint = CGPointMake((self.width - stringSize.width) * .5, characterPosition);
         
         //Strings are always drawn from top left. Calculate the right pos to draw it on bottom center.
         CGPoint stringPoint = CGPointMake(characterPoint.x, characterPoint.y - stringSize.height);
         
         //Save the current context and do the character rotation magic.
         CGContextSaveGState(context);
         CGContextTranslateCTM(context, characterPoint.x, characterPoint.y);
         //CGAffineTransform textTransform = CGAffineTransformMakeRotation(angle + M_PI_2);
         //CGContextConcatCTM(context, textTransform);
         CGContextTranslateCTM(context, -characterPoint.x, -characterPoint.y);
         
         //Draw the character
         [currentCharacter drawAtPoint:stringPoint withAttributes:self.textAttributes];
         
         //Restore context to make sure the rotation is only applied to this character.
         CGContextRestoreGState(context);
         
         //store the currentCharacter to use in the next run for kerning calculation.
         lastCharacter = currentCharacter;
    }
}

#pragma mark ---------- Setters

- (void)setText:(NSString *)text
{
    _text = text;
    [self setNeedsDisplay];
}

- (void)setTextAttributes:(NSDictionary *)textAttributes
{
    _textAttributes = textAttributes;
    [self setNeedsDisplay];
}

@end
