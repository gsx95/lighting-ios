//
//  Kallax.swift
//  leds_sb
//
//  Created by Georg Schwarz on 27.02.20.
//  Copyright © 2020 Georg Schwarz. All rights reserved.
//

import UIKit

class Kallax: NSObject {
    
    var cellIdentifier = ""
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selected: [Int: Bool] = [:]
    var panOveredCells: [Int:Bool] = [:]
    var selectCells = true
    let cellCount = 16
    var cells = [KallaxCell?](repeating: nil, count: 16)
    
    var rows: [[KallaxCell]] = []
    var cols: [[KallaxCell]] = []
    
    func setView(collectionView: UICollectionView, cellIdentifier: String) {
        let collectionView = collectionView
        self.cellIdentifier = cellIdentifier
        self.collectionView = collectionView
        let columnLayout = KallaxLayout()
        collectionView.collectionViewLayout = columnLayout
    }
    
    func calcCells() {
        rows.append([cells[0]!, cells[1]!, cells[2]!, cells[3]!])
        rows.append([cells[4]!, cells[5]!, cells[6]!, cells[7]!])
        rows.append([cells[8]!, cells[9]!, cells[10]!, cells[11]!])
        rows.append([cells[12]!, cells[13]!, cells[14]!, cells[15]!])
        for num in 0...3 {
            cols.append([cells[num]!, cells[num+4]!, cells[num+8]!, cells[num+12]!])
        }
    }
    
    func getRow(cell: KallaxCell) -> Int {
        return cell.num / 4
    }
    
    func getCol(cell: KallaxCell) -> Int {
        return cell.num % 4
    }
    
    func colorCellsGradient(color1: UIColor, color2: UIColor, mode: GradientMode) {
        var grads: [[CGColor]] = []
        
        var minNum = 4
        var maxNum = -1
        
        var getNum: ((KallaxCell) -> Int)
        
        if(mode == .TopBottom) {
            getNum = getRow
        }else {
            getNum = getCol
        }
        for (index, _) in selected {
            let cell = cells[index]!
            let r = getNum(cell)
            minNum = min(minNum, r)
            maxNum = max(maxNum, r)
        }
        
        if(maxNum - minNum == 3) {
            let c1 = color1
            let c2 = color1.toColor(color2, percentage: 0.25)
            let c3 = color1.toColor(color2, percentage: 0.5)
            let c4 = color1.toColor(color2, percentage: 0.75)
            let c5 = color2
            let g1 = [c1.cgColor, c2.cgColor]
            let g2 = [c2.cgColor, c3.cgColor]
            let g3 = [c3.cgColor, c4.cgColor]
            let g4 = [c4.cgColor, c5.cgColor]
            grads = [g1, g2, g3, g4]
        }else if(maxNum - minNum == 2) {
            let c1 = color1
            let c2 = color1.toColor(color2, percentage: 0.33)
            let c3 = color1.toColor(color2, percentage: 0.66)
            let c4 = color2
            let g1 = [c1.cgColor, c2.cgColor]
            let g2 = [c2.cgColor, c3.cgColor]
            let g3 = [c3.cgColor, c4.cgColor]
            grads = [g1, g2, g3]
        }else if(maxNum - minNum == 1) {
            let c1 = color1
            let c2 = color1.toColor(color2, percentage: 0.5)
            let c3 = color2
            let g1 = [c1.cgColor, c2.cgColor]
            let g2 = [c2.cgColor, c3.cgColor]
            grads = [g1, g2]
        } else {
            let c1 = color1
            let c2 = color2
            let g1 = [c1.cgColor, c2.cgColor]
            grads = [g1]
        }
        for (index, _) in selected {
            let cell = cells[index]!
            if(mode == .TopBottom){
                cell.gradientTopDown(colors: grads[getNum(cell) - minNum])
            }else{
                cell.gradientLeftRight(colors: grads[getNum(cell) - minNum])
            }
        }
        

    }
    
    func colorCellsAll(color: UIColor) {
        for i in 0...cells.count-1 {
            let cell = cells[i]
            cell?.color(color: color)
        }
    }
    
    func colorCellsSelected(color: UIColor) {
        for (index, _) in selected {
            let cell = cells[index]
            cell?.color(color: color)
        }
    }
    
    func isCellSelected(cell: KallaxCell) -> Bool{
        let ip = collectionView.indexPath(for: cell)
        let isSelected = selected[ip!.item] != nil
        return isSelected
    }
    
    func selectCell(cell: KallaxCell, select: Bool) {
        let ip = collectionView.indexPath(for: cell)
        if(select){
            self.selected[ip!.item] = true
            cell.setCellSelected()
        }else {
            self.selected[ip!.item] = nil
            cell.setCellUnselected()
        }
    }
    
    func selectAll() {
        let all = rows[0] + rows[1] + rows[2] + rows[3]
        selectMultiple(half: all)
    }
    
    func deselectAll() {
        selected = [:]
        selectCells = true
        panOveredCells = [:]
        for index in 0...cellCount-1 {
            let cell = cells[index]
            cell?.setCellUnselected()
        }
    }
    
    func panStarted(point: CGPoint) {
        panOveredCells = [:]
        let indexPath = self.collectionView.indexPathForItem(at: point)
        let cell = self.collectionView.cellForItem(at: indexPath!) as! KallaxCell
        self.selectCells = self.selected[indexPath!.item] == nil
        panOveredCells[indexPath!.item] = true
        if(self.selectCells) {
            self.selected[indexPath!.item] = true
            cell.setCellSelected()
        } else {
            self.selected[indexPath!.item] = nil
            cell.setCellUnselected()
        }
    }
    func panEnded(point: CGPoint) {
        panOveredCells = [:]
    }
    
    func panOverCell(point: CGPoint) {
        let indexPath = self.collectionView.indexPathForItem(at: point)
        if let indexP = indexPath {
           let cell = self.collectionView.cellForItem(at: indexP) as! KallaxCell
           if(panOveredCells[indexP.item] != nil) {
               return
           }
           panOveredCells[indexP.item] = true
           if(self.selectCells) {
               self.selected[indexP.item] = true
               cell.setCellSelected()
           } else {
               self.selected[indexP.item] = nil
               cell.setCellUnselected()
           }
        }
    }
    // MARK: - UICollectionViewDataSource protocol
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath as IndexPath) as! KallaxCell
        cell.backgroundColor = UIColor.init(white: 1, alpha: 0)
        cell.setCellUnselected()
        cell.addBorders(index: indexPath.item, color: UIColor.white)
        cells[indexPath.item] = cell
        cell.num = indexPath.item
        return cell
    }

    // MARK: - UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! KallaxCell
        if(self.selected[indexPath.item] == nil) {
            self.selected[indexPath.item] = true
            cell.setCellSelected()
        }else {
            self.selected[indexPath.item] = nil
            cell.setCellUnselected()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.init(red: 0.92, green: 0.92, blue: 0.92, alpha: 1)
    }

    // change background color back when user releases touch
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.init(red:1, green: 1, blue:1, alpha: 0)
    }
    
    func selectTop() {
        let topHalf = rows[0] + rows[1]
        selectMultiple(half: topHalf)
    }
    
    func selectBottom() {
        let bottomHalf = rows[2] + rows[3]
        selectMultiple(half: bottomHalf)
    }
    
    func selectLeft() {
        let leftHalf = cols[0] + cols[1]
        selectMultiple(half: leftHalf)
    }
    
    func selectRight() {
        let rightHalf = cols[2] + cols[3]
        selectMultiple(half: rightHalf)
    }
    
    func selectMultiple(half: [KallaxCell]) {
        var allSelected = true
        for num in 0...half.count-1 {
            if (!isCellSelected(cell: half[num])) {
                allSelected = false
            }
        }
        for num in 0...half.count-1 {
            selectCell(cell: half[num], select: !allSelected)
        }
    }
}

extension UIColor {
    func toColor(_ color: UIColor, percentage: CGFloat) -> UIColor {
        let percentage = max(min(percentage, 1), 0)
        switch percentage {
        case 0: return self
        case 1: return color
        default:
            var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
            var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
            guard self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1) else { return self }
            guard color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2) else { return self }

            return UIColor(red: CGFloat(r1 + (r2 - r1) * percentage),
                           green: CGFloat(g1 + (g2 - g1) * percentage),
                           blue: CGFloat(b1 + (b2 - b1) * percentage),
                           alpha: CGFloat(a1 + (a2 - a1) * percentage))
        }
    }
}
