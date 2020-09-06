//
//  KallaxLayout.swift
//  leds_sb
//
//  Created by Georg Schwarz on 25.02.20.
//  Copyright © 2020 Georg Schwarz. All rights reserved.
//

import UIKit

class KallaxLayout: UICollectionViewFlowLayout {

     let cellsPerRow: Int

      override init() {
          self.cellsPerRow = 4
          super.init()
      }

      required init?(coder aDecoder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }

      override func prepare() {
          super.prepare()

          guard let collectionView = collectionView else { return }
        
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
          let marginsAndInsets = sectionInset.left + sectionInset.right + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
          let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
          itemSize = CGSize(width: itemWidth, height: itemWidth)

      }

      override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
          let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
          context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
          return context
      }
}
