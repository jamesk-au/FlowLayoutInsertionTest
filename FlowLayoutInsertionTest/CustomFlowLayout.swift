//
//  CustomFlowLayout.swift
//

import UIKit

let CustomSupplementaryElementKind = "CustomSupplementaryElementKind"

class CustomFlowLayout: UICollectionViewFlowLayout
{
    // MARK: Providing layout attributes

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard var attributesInRect = super.layoutAttributesForElements(in: rect) else { return nil }

        for attributes in attributesInRect where attributes.representedElementCategory == .cell {
            if let supplementaryAttributes = layoutAttributesForSupplementaryView(ofKind: CustomSupplementaryElementKind, at: attributes.indexPath) {
                attributesInRect.append(supplementaryAttributes)
            }
        }

        print("layoutAttributesForElements in \(rect) = ")
        attributesInRect.forEach({ print($0) })

        return attributesInRect
    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == CustomSupplementaryElementKind {
            let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)

            if let itemAttributes = layoutAttributesForItem(at: indexPath) {
                // Position square supplementary view at right edge of cell.
                attributes.frame = CGRect(x: itemAttributes.frame.maxX - itemSize.height,
                                          y: itemAttributes.frame.minY,
                                          width: itemSize.height, height: itemSize.height)
            }

            print("\(indexPath) layoutAttributesForSupplementaryView = \(attributes)\n")

            return attributes
        }

        return super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
    }

    // MARK: Responding to collection view updates

    var deletedIndexPaths = [IndexPath]()
    var insertedIndexPaths = [IndexPath]()

    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)

        for item in updateItems {
            switch (item.updateAction, item.indexPathBeforeUpdate, item.indexPathAfterUpdate) {
            case (.delete, let .some(indexPathBeforeUpdate), _):
                deletedIndexPaths.append(indexPathBeforeUpdate)
            case (.insert, _, let .some(indexPathAfterUpdate)):
                insertedIndexPaths.append(indexPathAfterUpdate)
            default:
                continue
            }
        }
    }

    override func indexPathsToDeleteForDecorationView(ofKind elementKind: String) -> [IndexPath] {
        if elementKind == CustomSupplementaryElementKind {
            return deletedIndexPaths
        }

        return super.indexPathsToDeleteForSupplementaryView(ofKind: elementKind)
    }

    override func indexPathsToInsertForSupplementaryView(ofKind elementKind: String) -> [IndexPath] {
        if elementKind == CustomSupplementaryElementKind {
            return insertedIndexPaths
        }

        return super.indexPathsToInsertForSupplementaryView(ofKind: elementKind)
    }

    override func initialLayoutAttributesForAppearingSupplementaryElement(ofKind elementKind: String, at elementIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.initialLayoutAttributesForAppearingSupplementaryElement(ofKind: elementKind, at: elementIndexPath)

        if elementKind == CustomSupplementaryElementKind {
            print("\(elementIndexPath) initialLayoutAttributesForAppearingSupplementaryElement = \(attributes)\n")
        }

        return attributes
    }

    override func finalLayoutAttributesForDisappearingSupplementaryElement(ofKind elementKind: String, at elementIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.finalLayoutAttributesForDisappearingSupplementaryElement(ofKind: elementKind, at: elementIndexPath)

        if elementKind == CustomSupplementaryElementKind {
            print("\(elementIndexPath) finalLayoutAttributesForDisappearingSupplementaryElement = \(attributes)\n")
        }

        return attributes
    }

    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        deletedIndexPaths = []
        insertedIndexPaths = []
    }
}
