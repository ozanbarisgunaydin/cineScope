//
//  TabBarViewController.swift
//
//
//  Created by Mert Karabulut on 20.02.2022.
//

import AppManagers
import AppResources
import Components
import Combine
import UIKit
import Utility

// MARK: - TabBarViewController
public final class TabBarViewController: UITabBarController {
    // MARK: - Data
    private var cancellables: [AnyCancellable] = []
    private var shapeLayer: CALayer?
    private lazy var normalAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.medium(12),
        .foregroundColor: UIColor.lightGray
    ]
    private lazy var selectedAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.bold(12),
        .foregroundColor: UIColor.white
    ]
    
    // MARK: - Constants
    private let totalCurveHeight: CGFloat = 14

    // MARK: - Publics
    public override var selectedViewController: UIViewController? {
        didSet {
            setTabBarItemFonts()
        }
    }
    public override var viewControllers: [UIViewController]? {
        didSet {
            setTabBarItemFonts()
        }
    }
    public override var selectedIndex: Int {
        didSet {
            setTabBarItemFonts()
        }
    }

    // MARK: - Base Components
    weak var router: TabBarRouter?

    // MARK: - Life Cycles
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        delegate = self
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarVisibility()
    }

    // MARK: - Setup UI
    public func setupUI() {
        configureTabBarAppearance()
    }

    // MARK: - Init
    public init(
        router: TabBarRouter
    ) {
        self.router = router
        super.init(nibName: String(describing: Self.self), bundle: Bundle.module)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Privates
private extension TabBarViewController {
    final func setNavigationBarVisibility() {
        navigationController?.setNavigationBarHidden(
            true,
            animated: true
        )
    }
}

// MARK: - Configuration
private extension TabBarViewController {
    final func setTabBarItemFonts() {
        viewControllers?.forEach {
            let attributes = $0 == selectedViewController ? selectedAttributes : normalAttributes
            $0.tabBarItem.setTitleTextAttributes(attributes, for: .normal)
        }
    }

    /// Configures tabBar's apperance properties with calling needed methods
    final func configureTabBarAppearance() {
        setTabBarColors()
        prepareTopCurveLayer()
        setTabBarItemFonts()
    }

    /// Configures tabBar's content color properties
    final func setTabBarColors() {
        tabBar.backgroundColor = .black
        
        let safeAraeHeight = UIWindow.key?.safeAreaInsets.bottom ?? 0
        let gradient = CAGradientLayer(layer: tabBar.layer)
        gradient.frame = .init(
            x: tabBar.bounds.minX,
            y: tabBar.bounds.minY,
            width: tabBar.bounds.width,
            height: tabBar.bounds.height + safeAraeHeight
        )
        gradient.colors = [
            UIColor.white.withAlphaComponent(0.1).cgColor,
            UIColor.white.withAlphaComponent(0.2).cgColor,
            UIColor.white.withAlphaComponent(0.1).cgColor
        ]
        gradient.locations = [0, 0.5, 1]
        tabBar.layer.insertSublayer(gradient, at: 0)
        tabBar.isTranslucent = false
    }

    /// Configures tabBar shadow properties
    final func setTabBarShadow() {
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -1)
        tabBar.layer.shadowRadius = 0
        tabBar.layer.shadowColor = UIColor.backgroundRed.cgColor
        tabBar.layer.shadowOpacity = 1
    }

    final func prepareTopCurveLayer() {
        /// Shape layer preparing
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()

        /// Layer path properties
        shapeLayer.strokeColor = UIColor.separator.withAlphaComponent(0.2).cgColor
        shapeLayer.fillColor = UIColor.curveBackground.cgColor
        shapeLayer.lineWidth = 3.0

        /// Layer inserting
        tabBar.layer.insertSublayer(shapeLayer, at: 0)

        if let oldShapeLayer = self.shapeLayer {
            tabBar.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            tabBar.layer.insertSublayer(shapeLayer, at: 0)
        }

        self.shapeLayer = shapeLayer
    }


    /// Creates and returns a custom CGPath for shaping a curved top portion of a tab bar.
    ///
    /// The generated path is used for creating a custom shape to be applied to the `mask` property of a UIView,
    /// such as a tab bar, to achieve a curved appearance.
    ///
    /// - Returns: A CGPath representing the curved shape.
    final func createPath() -> CGPath {
        let path = UIBezierPath()
        let totalCurveWidth: CGFloat = 110
        let totalCurveHeight: CGFloat = 14
        let curveSectionWidth: CGFloat = 22
        let shadowDifference: CGFloat = 2
        let totalCurveDirectWidth = totalCurveWidth - (2 * curveSectionWidth) + shadowDifference

        let tabBarMidX = tabBar.bounds.midX
        let tabBarMinY = tabBar.bounds.minY

        let curveStartX = (tabBarMidX - (totalCurveWidth / 2))
        let curveStartPoint = CGPoint(
            x: curveStartX,
            y: 0
        )
        let curveLeftTopEndPoint = CGPoint(
            x: curveStartX + curveSectionWidth,
            y: -totalCurveHeight
        )

        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: curveStartPoint)

        let leftBottomControlPoint = CGPoint(
            x: curveStartPoint.x + curveSectionWidth / 2,
            y: tabBarMinY
        )

        let leftTopControlPoint = CGPoint(
            x: curveStartPoint.x + curveSectionWidth / 2,
            y: -totalCurveHeight
        )

        path.addCurve(
            to: curveLeftTopEndPoint,
            controlPoint1: leftBottomControlPoint,
            controlPoint2: leftTopControlPoint
        )

        let curveRightTopStartPoint = CGPoint(
            x: curveLeftTopEndPoint.x + totalCurveDirectWidth,
            y: -totalCurveHeight
        )
        path.addLine(to: curveRightTopStartPoint)


        let curveRightBottomEndPoint = CGPoint(
            x: curveRightTopStartPoint.x + curveSectionWidth,
            y: tabBarMinY
        )

        let rightTopControlPoint = CGPoint(
            x: curveRightTopStartPoint.x + curveSectionWidth / 2,
            y: -totalCurveHeight
        )

        let rightBottomControlPoint = CGPoint(
            x: curveRightTopStartPoint.x + curveSectionWidth / 2,
            y: tabBarMinY
        )

        path.addCurve(
            to: curveRightBottomEndPoint,
            controlPoint1: rightTopControlPoint,
            controlPoint2: rightBottomControlPoint
        )

        path.addLine(to: CGPoint(x: tabBar.bounds.width, y: 0))

        return path.cgPath
    }
}

// MARK: - UITabBarControllerDelegate
extension TabBarViewController: UITabBarControllerDelegate {
    public func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController
    ) -> Bool {
        return true
    }
}
