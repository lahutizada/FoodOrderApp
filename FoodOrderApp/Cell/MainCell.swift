import UIKit

class MainCell: UICollectionViewCell {
    
    @IBOutlet weak var menuItem: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupLabel()
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true
    }
    
    private func setupLabel() {
        itemLabel.backgroundColor = UIColor.systemGray5
        itemLabel.textAlignment = .center
        itemLabel.clipsToBounds = true
        itemLabel.layer.cornerRadius = 12
    }
    
    func configure(category: MenuCategory) {
        itemLabel.text = category.title
        menuItem.image = UIImage(named: category.imageName)
    }
}
