
import UIKit

class SwipeToZoomFlowLayout: UICollectionViewFlowLayout {
    
    /// 縮放比例
    struct Scale: Equatable {
        // 寬度縮放比例
        var x: CGFloat
        // 高度縮方比例
        var y: CGFloat
        
        static var `default`: Scale {
            return Scale(x: 1, y: 1)
        }
    }
    
    /// cell 縮放比例
    var cellScale: Scale = .default
    
    var orignPading: CGFloat = 0
    /// cell 滑動方向兩邊的 Pading
    var pading: CGFloat = 0
    /// cell 的長寬比
    var proportion: Scale = .default
    /// 是否將螢幕長寬考慮計算 item Size
    var isAutoSizeForScreenSize: Bool = false
    /// 淡入淡出效果
    var adjustAlpha: CGFloat = 0.95
    

    init(scale: Scale, pading: CGFloat = 0) {
        super.init()
        cellScale = scale
        orignPading = pading
    }
    
    // MARK: StoryBoard 測試用
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        cellScale = Scale(x: 0.5, y: 1)
        orignPading = 20

    }
        
    
    override func prepare() {
        super.prepare()
        
        scrollDirection = .vertical
        
        defineItemSize()
        
    }
    
    /// 指定Ture: 滑動時是否需要更改Layout
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
           return true
       }
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        let willDisplayLayoutAttributes = super.layoutAttributesForElements(in: rect) ?? []

        guard let collectionView = collectionView else { return willDisplayLayoutAttributes }

        // 計算可視範圍
        // 原理: collectionView fram 計算 ContentSize 的偏移量
        let offsetTransform = CGAffineTransform(translationX: collectionView.contentOffset.x, y: collectionView.contentOffset.y)
        
        // 第一次 applying frame 計算設定偏移量
        // 所得到的 可視範圍為 view (collectionView contentView） 對 collectionView.superView 的座標
        // 第二次 applying 是將 座標體系轉為 collectionView 階層內的座標（ contentView 對 collectionView )
        // CGPoint.zero 開始計算
        let visiableRect = collectionView.frame.applying(offsetTransform).applying(CGAffineTransform(translationX: -collectionView.frame.minX, y: -collectionView.frame.minY))
                

        return scrollDirection == .horizontal ? horizontalLayoutAttributesForElements(visiableRect: visiableRect, layoutAttributes: willDisplayLayoutAttributes) : verticalLayoutAttributesForElements(visiableRect: visiableRect, layoutAttributes: willDisplayLayoutAttributes)
    }

    
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {

        guard let collectionView = collectionView else { return .zero }

        let offsetTransform = CGAffineTransform(translationX: collectionView.contentOffset.x, y: collectionView.contentOffset.y)

        let visiableRect = collectionView.frame.applying(offsetTransform).applying(CGAffineTransform(translationX: -collectionView.frame.minX, y: -collectionView.frame.minY))

        let attributes = self.layoutAttributesForElements(in: visiableRect)

        if scrollDirection == .horizontal {
            return horizontalCenterOffset(attributes, visiableRect, proposedContentOffset, velocity)
        }

        return verticalCenterOffset(attributes, visiableRect, proposedContentOffset)
    }
    

    
   
}

extension SwipeToZoomFlowLayout {
    
    fileprivate func defineItemSize() {
        
        if isAutoSizeForScreenSize {
            defineItemSizeForScreenSize()
        } else {
            difineItemSizeForCollectionViewSize()
        }
    }
    
    /// 自適應手機螢幕長寬既算 itemSize
    private func defineItemSizeForScreenSize() {
        
        pading = orignPading
        
        let deviceFrame = UIScreen.main.bounds
        
        let deviceProportion = deviceFrame.height / deviceFrame.width
        
        var itemWidth = deviceFrame.width
        
        // 判斷螢幕比例（19.5 / 9 為 iphoneX 版型 ）
        if deviceProportion < 2.16 {
            itemWidth = deviceFrame.height * 9 / 19.5
            pading = (deviceFrame.width - itemWidth) / 2

        } else {
            itemWidth = itemWidth - 2 * pading
        }
        
        let itemHeight = itemWidth * proportion.y / proportion.x
        
        itemSize = .init(width: itemWidth, height: itemHeight)
        
        guard let collectionView = collectionView else { return }
        collectionView.contentInset = .init(top: 0, left: pading, bottom: 0, right: pading)

    }
    
    /// 自適應collectionView長寬既算 itemSize
    private func difineItemSizeForCollectionViewSize() {
                
        pading = orignPading

        guard let collectionView = collectionView else { return }
        
        let width = collectionView.bounds.width
        
        let height = collectionView.bounds.height
        
        let itemHeight = height > width ? width - 2 * pading : height - 2 * pading
        
        let itemWidth = itemHeight * proportion.x / proportion.y
        
        itemSize = .init(width: itemWidth, height: itemHeight)
        
        if scrollDirection == .horizontal {
            pading = (width - itemWidth) / 2
            collectionView.contentInset = .init(top: 0, left: pading, bottom: 0, right: pading )
            return
        }
        pading = (height - itemHeight) / 2

        collectionView.contentInset = .init(top: pading, left: 0, bottom: pading, right: 0)
    }
    
}


// MARK: Horizontal
extension SwipeToZoomFlowLayout {
    
    /// 製作水平方向滑動的 layoutAttributes
    private func horizontalLayoutAttributesForElements(visiableRect rect: CGRect, layoutAttributes: [UICollectionViewLayoutAttributes])-> [UICollectionViewLayoutAttributes] {
        
        guard !(cellScale == .default) else { return layoutAttributes }
        
        let totalOffset = itemSize.width + pading
        
        let centerX = rect.minX + rect.width / 2
                
        layoutAttributes.forEach {
            guard rect.intersects($0.frame) else { return }
            
            let attCenterX = $0.center.x
            
            let distance = abs(attCenterX - centerX)
            
            let widthScale = 1 + (cellScale.x - 1) * distance / totalOffset
            
            let heightScale = 1 + (cellScale.y - 1) * distance / totalOffset
            
            let alpha = 1 + (adjustAlpha - 1) * distance / totalOffset
                                    
            var transform3d = CATransform3D()

            
            // 水平方向縮放
            transform3d.m11 = widthScale
            // 傳值方向縮放
            transform3d.m22 = heightScale
           
                        
            $0.transform = CATransform3DGetAffineTransform(transform3d)

            $0.alpha = alpha
        }
    
        return layoutAttributes
    }
    
    
     private func horizontalCenterOffset(_ attributes: [UICollectionViewLayoutAttributes]?,_ visiableRect: CGRect, _ proposedContentOffset: CGPoint, _ velocity: CGPoint) -> CGPoint {
        // 負左往右 正右往左
        
        let isRightToLeft: Bool = velocity.x < 0 ? false : true
                
        var adjustAttributes : UICollectionViewLayoutAttributes?
        
        let centerX = visiableRect.minX + visiableRect.width / 2

        attributes?.forEach {
            let candAttr : UICollectionViewLayoutAttributes? = adjustAttributes
            if let candAttr = candAttr {
                if abs( $0.center.x - centerX) < abs(candAttr.center.x - centerX) {
                    adjustAttributes = $0
                }
            } else {
                adjustAttributes = $0
                return
            }
        }
        
        if var adjustAttributes = adjustAttributes,
           let attributes = attributes{
            
            let indexPath = adjustAttributes.indexPath
            
            let adjustRow = isRightToLeft ? indexPath.row + 1 : indexPath.row - 1
            
            if let index = attributes.firstIndex(where: { $0.indexPath.row == adjustRow }) {
                adjustAttributes = attributes[index]
            }
            
            return CGPoint(x: adjustAttributes.center.x - visiableRect.width / 2, y: proposedContentOffset.y)
        }
        
        return .zero
    }
    
}


// MARK: vertical
extension SwipeToZoomFlowLayout {
    
    
    private func verticalLayoutAttributesForElements(visiableRect rect: CGRect, layoutAttributes: [UICollectionViewLayoutAttributes])-> [UICollectionViewLayoutAttributes]? {
        
        guard !(cellScale == .default) else { return layoutAttributes }
        
        let totalOffset = itemSize.height
        
        let centerY = rect.minY + rect.height / 2

                
        layoutAttributes.forEach {
            guard rect.intersects($0.frame) else { return }
            
            let attCenterY = $0.center.y
            
            let distance = abs(attCenterY - centerY)
            
            let widthScale = 1 + (cellScale.x - 1) * distance / totalOffset
            
            let heightScale = 1 + (cellScale.y - 1) * distance / totalOffset
            
            let alpha = 1 + (adjustAlpha - 1) * distance / totalOffset
            
            
            var transform3d = CATransform3D()
           
            transform3d.m11 = widthScale
            
            transform3d.m22 = heightScale

            $0.transform = CATransform3DGetAffineTransform(transform3d)
            
            $0.alpha = alpha

        }
    
        return layoutAttributes
    }
    
    
    
    private func verticalCenterOffset(_ attributes: [UICollectionViewLayoutAttributes]?,_ visiableRect: CGRect, _ proposedContentOffset: CGPoint) -> CGPoint {
        
        var adjustAttributes : UICollectionViewLayoutAttributes?
        
        let centerY = visiableRect.minY + visiableRect.height / 2

        attributes?.forEach {
            let candAttr : UICollectionViewLayoutAttributes? = adjustAttributes
            if let candAttr = candAttr {
                if abs($0.center.y - centerY) < abs(candAttr.center.y - centerY) {
                    adjustAttributes = $0
                    
                }
            } else {
                adjustAttributes = $0
                return
            }
        }
        
        if let adjustAttributes = adjustAttributes {
            return CGPoint(x: proposedContentOffset.x, y: adjustAttributes.center.y - visiableRect.height / 2)
        }
        
        return .zero
    }
        
    
    
}


