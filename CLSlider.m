/**
 * CLSlider.m
 * CosteliqueKit Library
 *
 * Copyright (c) 2018 Georgiy Chremnikh.
 * All rights reserved.
 */

#import "CLSlider.h"

IB_DESIGNABLE @interface CLSlider ()

@property (nonatomic, readwrite) UIControlState state;

@property (nonatomic, strong) IBInspectable UIImage *minImage;
@property (nonatomic, strong) IBInspectable UIImage *maxImage;

@end

@implementation CLSlider {
	UIImageView *minTrack;
	UIImageView *maxTrack;
	UIImageView *thumb;

	UIImageView * _Nullable leftImage;
	UIImageView * _Nullable rightImage;
	UIImageView * _Nullable thumbImage;
    
    UIImage *_stateNormalRightImage;
    UIImage *_stateNormalLeftImage;
	UIImage *_stateNormalThumbImage;
    UIImage *_stateHighlightedRightImage;
    UIImage *_stateHighlightedLeftImage;
	UIImage *_stateHighlightedThumbImage;
}

@synthesize state = _state;

#pragma mark - Constructor methods

- (instancetype)init {
	if (self = [super init]) {
		[self setDefaultValues];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self setDefaultValues];
	}
	return self;
}

- (void)setDefaultValues {
	self.backgroundColor = [UIColor clearColor];

	_value = 0.5f;
	_minimumValue = 0.0f;
	_maximumValue = 1.0f;
	_trackHeight = 2.0f;
	_thumbRadius = 28.0f;
	_continues = YES;
	_horizontal = YES;
	_shadow = YES;
}

#pragma mark - Setter methods

- (void)setState:(UIControlState)state {
	switch (state) {
		case UIControlStateNormal:
			if (leftImage != nil && _stateNormalLeftImage != nil) {
				leftImage.image = _stateNormalLeftImage;
			}
			if (rightImage != nil && _stateNormalRightImage != nil) {
				rightImage.image = _stateNormalRightImage;
			}
			if (thumbImage != nil && _stateNormalThumbImage != nil) {
				thumbImage.image = _stateNormalThumbImage;
			}
			break;

		case UIControlStateHighlighted:
			if (leftImage != nil && _stateHighlightedLeftImage != nil) {
				leftImage.image = _stateHighlightedLeftImage;
			}
			if (rightImage != nil && _stateHighlightedRightImage != nil) {
				rightImage.image = _stateHighlightedRightImage;
			}
			if (thumbImage != nil && _stateHighlightedThumbImage != nil) {
				thumbImage.image = _stateHighlightedThumbImage;
			}
			break;

		default:
			break;
	}
}

- (void)setMinImage:(UIImage *)minImage {
	[self setLeftImage:minImage forState:UIControlStateNormal];
}

- (void)setMaxImage:(UIImage *)maxImage {
	[self setRightImage:maxImage forState:UIControlStateNormal];
}

- (void)setValue:(float)value {
	if (value < _minimumValue) {
		value = _minimumValue;
	} else if (value > _maximumValue) {
		value = _maximumValue;
	}
	_value = value;
}

- (void)setMinimumValue:(float)minimumValue {
	if (minimumValue > _value) {
		if (minimumValue > _maximumValue) {
			minimumValue = _maximumValue - 1;
		}
		_value = minimumValue;
	}
	_minimumValue = minimumValue;
}

- (void)setMaximumValue:(float)maximumValue {
	if (_maximumValue < _value) {
		if (_maximumValue < _minimumValue) {
			_maximumValue = _minimumValue + 1;
		}
		_value = maximumValue;
	}
	_maximumValue = maximumValue;
}

- (void)setTrackHeight:(float)trackHeight {
	if (trackHeight < 2.0f) {
		trackHeight = 2.0f;
	} else if (trackHeight > self.frame.size.width) {
		trackHeight = self.frame.size.width;
	}
	_trackHeight = trackHeight;
}

- (void)setThumbRadius:(float)thumbRadius {
	if (thumbRadius < 10.0f) {
		thumbRadius = 10.0f;
	} else if (thumbRadius > self.frame.size.width) {
		thumbRadius = self.frame.size.width;
	}
	_thumbRadius = thumbRadius;
}

- (void)setLeftImage:(UIImage *)image forState:(UIControlState)state {
    switch (state) {
        case UIControlStateNormal:
            _stateNormalLeftImage = image;
            break;
            
        case UIControlStateHighlighted:
            _stateHighlightedLeftImage = image;
            break;
            
        default:
            NSLog(@"Don't available the control state '%u' for the CLSlider class!", (unsigned)state);
            break;
    }
}

- (void)setRightImage:(UIImage *)image forState:(UIControlState)state {
	switch (state) {
		case UIControlStateNormal:
			_stateNormalRightImage = image;
			break;

		case UIControlStateHighlighted:
			_stateHighlightedRightImage = image;
			break;

		default:
			NSLog(@"Don't available the control state '%u' for the CLSlider class!", (unsigned)state);
			break;
	}
}

- (void)setThumbImage:(UIImage *)image forState:(UIControlState)state {
	switch (state) {
		case UIControlStateNormal:
			_stateNormalThumbImage = image;
			break;

		case UIControlStateHighlighted:
			_stateHighlightedThumbImage = image;
			break;

		default:
			NSLog(@"Don't available the control state '%u' for the CLSlider class!", (unsigned)state);
			break;
	}
}

- (void)setValue:(float)value animated:(BOOL)animated {
	float diffrent = (value - _value - _minimumValue) / _maximumValue;
	diffrent = diffrent > 0 ?: -diffrent;
	[self setValue:value];

	CGRect thumbFrame = thumb.frame, leftMask = minTrack.frame, rightMask = maxTrack.frame;
	if ([self isHorizontal]) {
		thumbFrame.origin = (CGPoint){minTrack.frame.size.width * ((_value - _minimumValue) / _maximumValue) - _thumbRadius / 2 + minTrack.frame.origin.x, self.frame.size.height / 2 - _thumbRadius / 2};
		leftMask.size = CGSizeMake(minTrack.frame.size.width * ((_value - _minimumValue) / _maximumValue), _trackHeight);
		leftMask.origin = CGPointMake(0, 0);
		rightMask.size = CGSizeMake(maxTrack.frame.size.width * (1 - ((_value - _minimumValue) / _maximumValue)), _trackHeight);
		rightMask.origin = CGPointMake(maxTrack.frame.size.width - rightMask.size.width, 0);
	}
	else {
		thumbFrame.origin = (CGPoint){self.frame.size.width / 2 - _thumbRadius / 2, minTrack.frame.size.height * ((_value - _minimumValue) / _maximumValue) - _thumbRadius / 2 + minTrack.frame.origin.y};
		leftMask.size = CGSizeMake(_trackHeight, minTrack.frame.size.height * (1 - ((_value - _minimumValue) / _maximumValue)));
		leftMask.origin = CGPointMake(0, minTrack.frame.size.height - leftMask.size.height);
		rightMask.size = CGSizeMake(_trackHeight, minTrack.frame.size.height * ((_value - _minimumValue) / _maximumValue));
		rightMask.origin = CGPointMake(0, 0);
	}

	if (animated == YES) {
		[UIView animateWithDuration:diffrent * 2 animations:^{
			thumb.frame = thumbFrame;

			minTrack.maskView.frame = leftMask;
			maxTrack.maskView.frame = rightMask;
		}];
	}
	else {
		thumb.frame = thumbFrame;

		minTrack.maskView.frame = leftMask;
		maxTrack.maskView.frame = rightMask;
	}
}

#pragma mark - Rendering methods

- (void)drawRect:(CGRect)dirtyRect {
	[super drawRect:dirtyRect];

	if (_stateNormalLeftImage) {
		[self setLeftImage];
	}

	if (_stateNormalRightImage) {
		[self setRightImage];
	}

	[self setLeftTrack];
	[self setRightTrack];
	[self setThumb];
}

- (void)setLeftImage {
	if (leftImage == nil) {
		leftImage = [[UIImageView alloc] initWithImage:_stateNormalLeftImage];
		leftImage.contentMode = UIViewContentModeScaleAspectFit;
	}

	CGFloat aspectRatio = leftImage.frame.size.width / leftImage.frame.size.height;
	CGRect imageRect;
	if ([self isHorizontal]) {
		imageRect = (CGRect){0.0f, self.frame.size.height / 2 -  ((_thumbRadius * 0.8f) / 2), _thumbRadius * aspectRatio * 0.8f, _thumbRadius  * 0.8f};
	}
	else {
		imageRect = (CGRect){self.frame.size.width / 2 - _thumbRadius * aspectRatio * 0.4f, self.frame.size.height - _thumbRadius  * 0.8f, _thumbRadius * aspectRatio * 0.8f, _thumbRadius  * 0.8f};
	}

	leftImage.frame = imageRect;

	[self addSubview:leftImage];
}

- (void)setRightImage {
	if (rightImage == nil) {
		rightImage = [[UIImageView alloc] initWithImage:_stateNormalRightImage];
		rightImage.contentMode = UIViewContentModeScaleAspectFit;
	}

	CGFloat aspectRatio = rightImage.frame.size.width / rightImage.frame.size.height;
	CGRect imageRect;
	if ([self isHorizontal]) {
		imageRect = (CGRect){self.frame.size.width - _thumbRadius  * aspectRatio * 0.8f, self.frame.size.height / 2 -  ((_thumbRadius * 0.8f) / 2), _thumbRadius * aspectRatio * 0.8f, _thumbRadius  * 0.8f};
	}
	else {
		imageRect = (CGRect){self.frame.size.width / 2 - _thumbRadius * aspectRatio * 0.4f, 0.0f, _thumbRadius * aspectRatio * 0.8f, _thumbRadius  * 0.8f};
	}

	rightImage.frame = imageRect;

	[self addSubview:rightImage];
}

- (void)setLeftTrack {
	UIColor *color = _leftTrackTintColor ? _leftTrackTintColor : [UIColor colorWithRed:(0.0f / 255.0f) green:(122.0f / 255.0f) blue:(255.0f / 255.0f) alpha:1.0f];
	CGRect minTrackFrame;
	if ([self isHorizontal]) {
		minTrackFrame = (CGRect){leftImage.frame.size.width * 1.2f, self.frame.size.height / 2 - _trackHeight / 2, self.frame.size.width - leftImage.frame.size.width * 1.2f - rightImage.frame.size.width * 1.2f, _trackHeight};
	}
	else {
		minTrackFrame = (CGRect){self.frame.size.width / 2 - _trackHeight / 2, rightImage.frame.size.height * 1.5f, _trackHeight, self.frame.size.height - (rightImage.frame.size.height + leftImage.frame.size.height) * 1.5f};
	}

	minTrack = [[UIImageView alloc] initWithFrame:minTrackFrame];
	minTrack.backgroundColor = color;
	minTrack.layer.cornerRadius = _trackHeight / 2;

	UIImageView *mask = [[UIImageView alloc] init];
	CGRect maskFrame = minTrack.frame;
	if ([self isHorizontal]) {
		maskFrame.size = CGSizeMake(minTrack.frame.size.width * ((_value - _minimumValue) / _maximumValue), _trackHeight);
		maskFrame.origin = CGPointMake(0, 0);
	} else {
		maskFrame.size = CGSizeMake(_trackHeight, minTrack.frame.size.height * ((_value - _minimumValue) / _maximumValue));
		maskFrame.origin = CGPointMake(0, minTrack.frame.size.height - maskFrame.size.height);
	}
	mask.frame = maskFrame;
	mask.backgroundColor = [UIColor redColor];

	minTrack.maskView = mask;

	[self addSubview:minTrack];
}

- (void)setRightTrack {
	UIColor *color = _rightTrackTintColor ? _rightTrackTintColor : [UIColor colorWithRed:(183.0f / 255.0f) green:(183.0f / 255.0f) blue:(183.0f / 255.0f) alpha:1.0f];
	CGRect maxTrackFrame;
	if ([self isHorizontal]) {
		maxTrackFrame = (CGRect){leftImage.frame.size.width * 1.2f, self.frame.size.height / 2 - _trackHeight / 2, self.frame.size.width - leftImage.frame.size.width * 1.2f - rightImage.frame.size.width * 1.2f, _trackHeight};
	}
	else {
		maxTrackFrame = (CGRect){self.frame.size.width / 2 - _trackHeight / 2, rightImage.frame.size.height * 1.5f, _trackHeight, self.frame.size.height - (rightImage.frame.size.height + leftImage.frame.size.height) * 1.5f};
	}
	maxTrack = [[UIImageView alloc] initWithFrame:maxTrackFrame];
	maxTrack.backgroundColor = color;
	maxTrack.layer.cornerRadius = _trackHeight / 2;

	UIImageView *mask = [[UIImageView alloc] init];
	CGRect maskFrame = maxTrack.frame;
	if ([self isHorizontal]) {
		maskFrame.size = CGSizeMake(maxTrack.frame.size.width * (1 - ((_value - _minimumValue) / _maximumValue)), _trackHeight);
		maskFrame.origin = CGPointMake(maxTrack.frame.size.width - maskFrame.size.width, 0);
	} else {
		maskFrame.size = CGSizeMake(_trackHeight, maxTrack.frame.size.height * (1 - ((_value - _minimumValue) / _maximumValue)));
		maskFrame.origin = CGPointMake(0, 0);
	}
	mask.frame = maskFrame;
	mask.backgroundColor = [UIColor redColor];

	maxTrack.maskView = mask;

	[self addSubview:maxTrack];
}

- (void)setThumb {
	UIColor *color = _thumbTintColor ? _thumbTintColor : [UIColor whiteColor];
	CGRect thumbFrame;
	if ([self isHorizontal]) {
		thumbFrame = (CGRect){minTrack.frame.size.width * ((_value - _minimumValue) / _maximumValue) - _thumbRadius / 2 + minTrack.frame.origin.x, self.frame.size.height / 2 - _thumbRadius / 2, _thumbRadius, _thumbRadius};
	}
	else {
		thumbFrame = (CGRect){self.frame.size.width / 2 - _thumbRadius / 2, minTrack.frame.size.height * (1 - ((_value - _minimumValue) / _maximumValue)) - _thumbRadius / 2 + minTrack.frame.origin.y, _thumbRadius, _thumbRadius};
	}
	thumb = [[UIImageView alloc] initWithFrame:thumbFrame];
	thumb.backgroundColor = color;

	if ([self hasShadow]) {
		[self setThumbShadow];
	}

	[self addSubview:thumb];
}

- (void)setThumbShadow {
	if (![thumb.backgroundColor isEqual:[UIColor clearColor]]) {
		thumb.layer.cornerRadius = _thumbRadius / 2;
		thumb.layer.shadowColor = [[UIColor colorWithRed:(195.0f / 255.0f) green:(195.0f / 255.0f) blue:(195.0f / 255.0f) alpha:1.0f] CGColor];
		thumb.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
		thumb.layer.shadowRadius = 2.0f;
		thumb.layer.shadowOpacity = 1.0f;
	}
}

#pragma mark - UIControl methods

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint pos = [touch locationInView:self];
	pos = [thumb convertPoint:pos fromView:self];
	if ([thumb pointInside:pos withEvent:event]) {
		self.state = UIControlStateHighlighted;
		if (_continues == YES) {
			[self sendActionsForControlEvents:UIControlEventValueChanged];
		}
		return YES;
	}
	return NO;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint pos = [touch locationInView:self];
	float value;
	if ([self isHorizontal]) {
		value = (pos.x - minTrack.frame.origin.x) / minTrack.frame.size.width;
	}
	else {
		value = (pos.y - minTrack.frame.origin.y) / minTrack.frame.size.height;
	}
	[self setValue:value animated:NO];
	if (_continues == YES) {
		[self sendActionsForControlEvents:UIControlEventValueChanged];
	}
	return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
	self.state = UIControlStateNormal;
	[self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark - NSCoding protocol methods

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super initWithCoder:aDecoder]) {
		[self setDefaultValues];
	}
	return self;
}

#pragma mark - Storyboard rendering

- (void)prepareForInterfaceBuilder {
	self.backgroundColor = [UIColor clearColor];
	[self drawRect:self.frame];
}

@end
