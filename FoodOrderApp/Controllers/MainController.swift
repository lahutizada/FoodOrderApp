import UIKit

class MainController: UIViewController  {
    
    @IBOutlet weak var collection: UICollectionView!
    
    private let cartButton = UIButton(type: .system)
    private let profileButton = UIButton(type: .system)
    private let cartBadgeLabel = UILabel()
    static weak var shared: MainController?
    var categoriesMain = MenuData.categories
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MainController.shared = self
        
        title = "Main"
        collection.dataSource = self
        collection.delegate = self
        view.addSubview(cartButton)
        view.bringSubviewToFront(cartButton)
        view.addSubview(profileButton)
        view.bringSubviewToFront(profileButton)
        setupCartButton()
        setupProfileButton()
        setupCollectionView()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateCartBadge),
            name: Notification.Name("cartUpdated"),
            object: nil
        )
        updateCartBadge()
    }

    @objc private func cartTapped() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "\(CartController.self)") as! CartController
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc private func profileTapped() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "\(ProfileController.self)") as! ProfileController
        
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: Config
extension MainController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categoriesMain.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "MainCell",
            for: indexPath
        ) as! MainCell
        
        let categoryMain = categoriesMain[indexPath.item]
        cell.configure(category: categoryMain)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedCategory = categoriesMain[indexPath.item]
        
        let controller = storyboard?.instantiateViewController(
            withIdentifier: "DishesController"
        ) as! DishesController
        
        controller.category = selectedCategory
        
        navigationController?.pushViewController(controller, animated: true)
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

//MARK: Setups
extension MainController {
    
    private func setupCollectionView() {
        
        view.addSubview(collection)
        collection.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            collection.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 62
            ),
            
            collection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collection.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupCartButton() {
        
        cartButton.setImage(UIImage(systemName: "cart"), for: .normal)
        cartButton.tintColor = .white
        cartButton.backgroundColor = .systemTeal
        
        cartButton.layer.cornerRadius = 28
        cartButton.clipsToBounds = false
        
        cartButton.addTarget(
            self,
            action: #selector(cartTapped),
            for: .touchUpInside
        )
        
        view.addSubview(cartButton)
        cartButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cartButton.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 0
            ),
            cartButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -16
            ),
            cartButton.widthAnchor.constraint(equalToConstant: 56),
            cartButton.heightAnchor.constraint(equalToConstant: 56)
        ])
        cartBadgeLabel.font = .systemFont(ofSize: 12, weight: .bold)
        cartBadgeLabel.textColor = .white
        cartBadgeLabel.backgroundColor = .systemRed
        cartBadgeLabel.textAlignment = .center
        cartBadgeLabel.layer.cornerRadius = 9
        cartBadgeLabel.clipsToBounds = true
        cartBadgeLabel.isHidden = true
        
        cartButton.addSubview(cartBadgeLabel)
        cartBadgeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cartBadgeLabel.topAnchor.constraint(equalTo: cartButton.topAnchor, constant: -4),
            cartBadgeLabel.trailingAnchor.constraint(equalTo: cartButton.trailingAnchor, constant: 4),
            cartBadgeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 18),
            cartBadgeLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    private func setupProfileButton() {
        
        profileButton.setImage(UIImage(systemName: "person"), for: .normal)
        profileButton.tintColor = .white
        profileButton.backgroundColor = .systemTeal
        
        profileButton.layer.cornerRadius = 28
        profileButton.clipsToBounds = true
        
        profileButton.addTarget(
            self,
            action: #selector(profileTapped),
            for: .touchUpInside
        )
        
        view.addSubview(profileButton)
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileButton.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 0
            ),
            profileButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 16
            ),
            profileButton.widthAnchor.constraint(equalToConstant: 56),
            profileButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    func cartButtonCenterInWindow() -> CGPoint? {
        guard let window = view.window else { return nil }
        let frame = cartButton.convert(cartButton.bounds, to: window)
        return CGPoint(x: frame.midX, y: frame.midY)
    }
    
    @objc private func updateCartBadge() {
        
        let count = CartManager.shared.itemsCount
        
        if count > 0 {
            cartBadgeLabel.text = "\(count)"
            cartBadgeLabel.isHidden = false
        } else {
            cartBadgeLabel.isHidden = true
        }
    }
}

//MARK: Animation
extension MainController {
    
    func bounceCartButton() {
        UIView.animate(withDuration: 0.15, animations: {
            self.cartButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { _ in
            UIView.animate(withDuration: 0.15) {
                self.cartButton.transform = .identity
            }
        }
    }
}
