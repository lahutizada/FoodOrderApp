import UIKit

class DishesCell: UICollectionViewCell {
    
    @IBOutlet weak var dishImage: UIImageView!
    @IBOutlet weak var dishName: UILabel!
    @IBOutlet weak var dishPrice: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var stack: UIStackView!
    
    private func setupUI() {
        dishImage.contentMode = .scaleAspectFill
        dishImage.clipsToBounds = true

        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 4

        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(
            top: 6,
            left: 10,
            bottom: 6,
            right: 10
        )

        stack.backgroundColor = .systemGray5
        stack.layer.cornerRadius = 12
        stack.clipsToBounds = true

        dishName.numberOfLines = 1
        dishName.lineBreakMode = .byTruncatingTail
        dishName.font = .systemFont(ofSize: 10, weight: .medium)

        dishPrice.font = .boldSystemFont(ofSize: 9)
        dishPrice.textColor = .label
    }
    
    var onAddTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addToCartButton.addTarget(
            self,
            action: #selector(addTapped),
            for: .touchUpInside
        )
        
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true
        setupUI()
    }

    @objc private func addTapped() {
        onAddTapped?()
    }
    
    func configure(with dish: Dish) {
        dishImage.image = UIImage(named: dish.imageName)
        dishName.text = dish.name
        dishPrice.text = "\(dish.price)₼"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dishImage.image = nil
        dishName.text = nil
        dishPrice.text = nil
    }
    
}

