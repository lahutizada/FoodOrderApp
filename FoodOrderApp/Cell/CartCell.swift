import UIKit

class CartCell: UITableViewCell {

    @IBOutlet weak var dishImage: UIImageView!
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var dishName: UILabel!
    @IBOutlet weak var dishPrice: UILabel!
    @IBOutlet weak var dishCount: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    var onQuantityChanged: ((Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        stepper.minimumValue = 0
                stepper.maximumValue = 99

                stepper.addTarget(
                    self,
                    action: #selector(stepperChanged),
                    for: .valueChanged
                )
    }
    func configure(with item: CartItem) {
            dishImage.image = UIImage(named: item.dish.imageName)
            dishName.text = item.dish.name
            dishPrice.text = "\(item.dish.price) ₼"
            dishCount.text = "\(item.quantity)"
            stepper.value = Double(item.quantity)
            dishImage.layer.cornerRadius = 8
            dishName.numberOfLines = 1
            dishName.lineBreakMode = .byTruncatingTail
        }

        @objc private func stepperChanged() {
            let value = Int(stepper.value)
            dishCount.text = "\(value)"
            onQuantityChanged?(value)
        }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    override func prepareForReuse() {
        super.prepareForReuse()
        transform = .identity
        alpha = 1
    }

}
