import UIKit

class DishesController: UIViewController {
    
    
    @IBOutlet weak var collection: UICollectionView!
    
    var category: MenuCategory!
    var dishes: [Dish] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = category.title
        collection.dataSource = self
        collection.delegate = self
    }
}

//MARK: Config
extension DishesController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        category.dishes.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "DishesCell",
            for: indexPath
        ) as! DishesCell
        
        let dish = category.dishes[indexPath.item]
        cell.configure(with: dish)
        
        cell.onAddTapped = { [weak self, weak cell] in
            guard
                let self = self,
                let cell = cell
            else { return }
            
            CartManager.shared.add(dish)
            self.animateAddToCart(from: cell.dishImage)
        }
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        let spacing: CGFloat = 10
        let itemsPerRow: CGFloat = 2
        
        let totalSpacing = spacing * (itemsPerRow - 1) + spacing * 2
        let width = (collectionView.bounds.width - totalSpacing) / itemsPerRow
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        10
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        10
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

//MARK: Animation
extension DishesController {
    
    private func hapticSuccess() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }
    
    private func animateAddToCart(from imageView: UIImageView) {
        
        guard let window = view.window else { return }
        
        let snapshot = imageView.snapshotView(afterScreenUpdates: false)!
        snapshot.frame = imageView.convert(imageView.bounds, to: window)
        snapshot.layer.cornerRadius = imageView.layer.cornerRadius
        snapshot.clipsToBounds = true
        
        snapshot.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        window.addSubview(snapshot)
        
        let endPoint = CGPoint(
            x: 36,
            y: window.safeAreaInsets.top + 36
        )
        
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: [.curveEaseOut],
            animations: {
                snapshot.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
            },
            completion: { _ in
                UIView.animate(
                    withDuration: 0.7,
                    delay: 0,
                    options: [.curveEaseIn],
                    animations: {
                        snapshot.center = endPoint
                        snapshot.transform = CGAffineTransform(scaleX: 0.15, y: 0.15)
                        snapshot.alpha = 0
                    },
                    completion: { _ in
                        snapshot.removeFromSuperview()
                        self.hapticSuccess()
                    }
                )
            }
        )
    }
}
