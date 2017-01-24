//
//  CustomSupplementaryView.swift
//

import UIKit

class CustomSupplementaryView: UICollectionReusableView
{
    var text: String? { didSet { label.text = text } }
    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        let padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        label.frame = UIEdgeInsetsInsetRect(bounds, padding)
        label.textAlignment = .center
        addSubview(label)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        text = nil
    }
}
