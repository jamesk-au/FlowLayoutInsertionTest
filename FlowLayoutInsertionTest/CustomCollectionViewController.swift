//
//  CustomCollectionViewController.swift
//

import UIKit

private let reuseIdentifier = "Cell"

class CustomCollectionViewController: UICollectionViewController
{
    var numItems = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView!.register(CustomSupplementaryView.self, forSupplementaryViewOfKind: CustomSupplementaryElementKind, withReuseIdentifier: CustomSupplementaryElementKind)
    }

    @IBAction func reload() {
        numItems = 1
        collectionView?.reloadData()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numItems
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

        // Cell is configured in storyboard with one label.
        for subview in cell.contentView.subviews {
            if let label = subview as? UILabel {
                label.text = "Item \(indexPath)"
            }
        }

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CustomSupplementaryElementKind, for: indexPath) as! CustomSupplementaryView
        view.text = "\(indexPath)"
        view.backgroundColor = .groupTableViewBackground
        view.layer.borderColor = UIColor.red.cgColor
        view.layer.borderWidth = 0.5
        return view
    }

    @IBAction func performInserts() {
        // Animations for supplementary views seem to glitch when more than one is inserted
        // at a time. In this example, there is one supplementary view for every item.
        // The glitches worsen when inserting even more items at once (e.g. 4 items).

        let insertedIndexPaths = [
            IndexPath(item: 0, section: 0),
            IndexPath(item: 1, section: 0)
        ]

        collectionView?.performBatchUpdates({
            self.numItems += insertedIndexPaths.count
            self.collectionView!.insertItems(at: insertedIndexPaths)
        })

        print("Inserted items at: \(insertedIndexPaths)\n")
    }
}
