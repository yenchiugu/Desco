#import "GeometryUtilities.h"

#define VALUE(_INDEX_) [NSValue valueWithCGPoint:points[_INDEX_]]
#define POINT(_INDEX_) [(NSValue *)[points objectAtIndex:_INDEX_] CGPointValue]

#pragma mark Bezier Utilities
// 從貝茲路徑裡取得點座標
void getPointsFromBezier(void *info, const CGPathElement *element)
{
    NSMutableArray *bezierPoints = (__bridge NSMutableArray *)info;
    
    // 取得路徑元素型別與其上的點
    CGPathElementType type = element->type;
    CGPoint *points = element->points;
    
    // 如果可用的話（根據型別），把點加入
    if (type != kCGPathElementCloseSubpath)
    {
        [bezierPoints addObject:VALUE(0)];
        if ((type != kCGPathElementAddLineToPoint) &&
            (type != kCGPathElementMoveToPoint))
            [bezierPoints addObject:VALUE(1)];
    }
    if (type == kCGPathElementAddCurveToPoint)
        [bezierPoints addObject:VALUE(2)];
}

NSArray *pointsFromBezierPath(UIBezierPath *bpath)
{
    NSMutableArray *points = [NSMutableArray array];
    CGPathApply(bpath.CGPath, (__bridge void *)points, getPointsFromBezier);
    return points;
}

#pragma mark Geometry Utilities
// 回傳給定矩形的中心點
CGPoint getRectCenter(CGRect rect)
{
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

CGPoint getRectUpperCenter(CGRect rect)
{
    return CGPointMake(CGRectGetMidX(rect), rect.origin.y + rect.size.height / 4);
}

CGPoint getRectLowerCenter(CGRect rect)
{
    return CGPointMake(CGRectGetMidX(rect), rect.origin.y + rect.size.height * 3 / 4);
}


// 根據給定中心點建立矩形
CGRect rectAroundCenter(CGPoint center, float dx, float dy)
{
    return CGRectMake(center.x - dx, center.y - dy, dx * 2, dy * 2);
}

// 兩個向量，正規化後，求出點積
float dotproduct (CGPoint v1, CGPoint v2)
{
    float dot = (v1.x * v2.x) + (v1.y * v2.y);
    float a = ABS(sqrt(v1.x * v1.x + v1.y * v1.y));
    float b = ABS(sqrt(v2.x * v2.x + v2.y * v2.y));
    dot /= (a * b);
    
    return dot;
}

BOOL isClockwise(CGPoint v1, CGPoint v2)
{
    return ((v1.x * v2.y - v1.y * v2.x) > 0) ? YES : NO;
}

// 回傳兩點的距離
float distance (CGPoint p1, CGPoint p2)
{
    float dx = p2.x - p1.x;
    float dy = p2.y - p1.y;
    
    return sqrt(dx*dx + dy*dy);
}

// 根據給定的原點，回傳點座標
CGPoint pointWithOrigin(CGPoint pt, CGPoint origin)
{
    return CGPointMake(pt.x - origin.x, pt.y - origin.y);
}

#pragma mark Circle Detection

// 計算並回傳最小的包圍矩形
CGRect boundingRect(NSArray *points)
{
    CGRect rect = CGRectZero;
    CGRect ptRect;
    
    for (int i = 0; i < points.count; i++)
    {
        CGPoint pt = POINT(i);
        ptRect = CGRectMake(pt.x, pt.y, 0.0f, 0.0f);
        rect = (CGRectEqualToRect(rect, CGRectZero)) ? ptRect : CGRectUnion(rect, ptRect);
    }
    return rect;
}

#define DX(p1, p2)  (p2.x - p1.x)
#define DY(p1, p2)  (p2.y - p1.y)
#define SIGN(NUM)   ((NUM) < 0 ? (-1) : 1)

float getTransitTolerance(CGPoint center, NSArray *points, float positive)
{
    float distance = acos(dotproduct(pointWithOrigin(POINT(0), center), pointWithOrigin(POINT(1), center)));
    for (int i = 1; i < (points.count - 1); i++) {
        float span = acos(dotproduct(pointWithOrigin(POINT(i), center), pointWithOrigin(POINT(i+1), center)));
        if ((positive && span > 0) || (!positive && span < 0)) {
            distance += span;
        }
    }
    return ABS(distance) - 2 * M_PI;
}

CGRect testForLetterO(NSArray *points, NSDate *firstTouchDate)
{
    if (points.count < 2) {
        return CGRectZero;
    }
    
    // 檢測1：在多短時間內必須完成手勢
    float duration = [[NSDate date] timeIntervalSinceDate:firstTouchDate];
    
    float maxDuration = 2.0f;
    if (duration > maxDuration) {
        return CGRectZero;
    }
    
    // 檢測2：方向變化的次數
    // 限制在4次左右
    int inflections = 0;
    for (int i = 2; i < (points.count - 1); i++) {
        float dx = DX(POINT(i), POINT(i-1));
        float dy = DY(POINT(i), POINT(i-1));
        float px = DX(POINT(i-1), POINT(i-2));
        float py = DY(POINT(i-1), POINT(i-2));
        
        if ((SIGN(dx) != SIGN(px)) || (SIGN(dy) != SIGN(py)))
            inflections++;
    }
    
    if (inflections > 5) {
        return CGRectZero;
    }
    
    // 檢測3：起點與終點必須在一定程度內靠在一起
    //float tolerance = [[[UIApplication sharedApplication] keyWindow] bounds].size.width / 3.0f;
    //if (distance(POINT(0), POINT(points.count - 1)) > tolerance) {
    //    return CGRectZero;
    //}
    
    // 檢測4：計算手勢劃過的角度
    CGRect circle = boundingRect(points);
    CGPoint center = getRectCenter(circle);
    float distance = ABS(acos(dotproduct(pointWithOrigin(POINT(0), center), pointWithOrigin(POINT(1), center))));
    for (int i = 1; i < (points.count - 1); i++)
        distance += ABS(acos(dotproduct(pointWithOrigin(POINT(i), center), pointWithOrigin(POINT(i+1), center))));
    
    float transitTolerance = distance - 2 * M_PI;
    
    if (transitTolerance < -(M_PI / 4.0f)) {
        return CGRectZero;
    }
    if (transitTolerance > M_PI) {
        return CGRectZero;
    }
    
    return circle;
}

char *guessLetter(NSArray *points) {
    // 檢測3：起點與終點必須在一定程度內靠在一起
    CGRect rect = boundingRect(points);
    float diagonal = distance(rect.origin, CGPointMake(rect.size.width, rect.size.height));
    if (distance(POINT(0), POINT(points.count - 1)) > diagonal * 0.7f) {
        return "S";
    } else {
        return "O";
    }
}

CGRect testForLetterS(NSArray *points, NSDate *firstTouchDate)
{
    if (points.count < 4) {
        return CGRectZero;
    }
    
    if (POINT(0).y > POINT(points.count - 1).y)
        return CGRectZero;
    
    /*
    BOOL turned = NO;
    for (int i = 2; i < (points.count - 1); i++) {
        BOOL clockwise = isClockwise(pointWithOrigin(POINT(i-1), POINT(i-2)), pointWithOrigin(POINT(i), POINT(i-1)));
        if (!turned && !clockwise) {
            turned = YES;
        } else if (turned && clockwise) {
            return CGRectZero;
        }
    }
    */
    
    // 檢測1：在多短時間內必須完成手勢
    //    float duration = [[NSDate date] timeIntervalSinceDate:firstTouchDate];
    //
    //    float maxDuration = 3.0f;
    //    if (duration > maxDuration) {
    //        return CGRectZero;
    //    }
    
    // 檢測2：方向變化的次數
    // 限制在4次左右
    int inflectionsX = 0;
    int inflectionsY = 0;
    for (int i = 2; i < (points.count - 1); i++) {
        float dx = DX(POINT(i), POINT(i-1));
        float dy = DY(POINT(i), POINT(i-1));
        float px = DX(POINT(i-1), POINT(i-2));
        float py = DY(POINT(i-1), POINT(i-2));
        
        if ((SIGN(dx) != SIGN(px)))
            inflectionsX++;
        if ((SIGN(dy) != SIGN(py)))
            inflectionsY++;
    }
    if (inflectionsX > 3 || inflectionsX < 2 || inflectionsY > 2) {
        return CGRectZero;
    }
    
    // 檢測4：計算手勢劃過的角度
    CGRect circle = boundingRect(points);
    CGPoint upperCenter = getRectUpperCenter(circle);
    CGPoint lowerCenter = getRectLowerCenter(circle);
    float upperSpan = getTransitTolerance(upperCenter, points, NO);
    float lowerSpan = getTransitTolerance(lowerCenter, points, YES);
    
    NSLog(@"upperspan: %f", upperSpan/2/M_PI);
    NSLog(@"lowerspan: %f", lowerSpan/2/M_PI);
    
    if (upperSpan < -(M_PI/2.0f) || upperSpan > M_PI/4.0f) {
        //return CGRectZero;
    }
    if (lowerSpan < -(M_PI/2.0f) || lowerSpan > M_PI/4.0f) {
        //return CGRectZero;
    }
    
    return circle;
}

