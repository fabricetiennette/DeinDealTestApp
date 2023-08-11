import UIKit

public class LoaderIndicator: UIView {
    
    private var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.accessibilityIdentifier = "containerView.LoaderIndicator"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var strokeContainerView: UIView = {
        let view = UIView()
        view.accessibilityIdentifier = "strokeContainerView.LoaderIndicator"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = UIColor(named: "main") ?? .magenta
        indicator.hidesWhenStopped = true
        indicator.accessibilityIdentifier = "indicator.LoaderIndicator"
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private var loaderBackgroundView: UIView?

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        indicator.color = UIColor(named: "main") ?? .magenta
    }

    public func showCircleStroke(indicator forView: UIView, frame: CGFloat = 60) {
        indicator.startAnimating()

        strokeContainerView.addSubview(indicator)
        forView.addSubview(strokeContainerView)

        NSLayoutConstraint.activate([
            strokeContainerView.centerYAnchor.constraint(equalTo: forView.centerYAnchor),
            strokeContainerView.centerXAnchor.constraint(equalTo: forView.centerXAnchor),
            strokeContainerView.widthAnchor.constraint(equalToConstant: frame + 10),
            strokeContainerView.heightAnchor.constraint(equalToConstant: frame + 10),

            indicator.centerYAnchor.constraint(equalTo: strokeContainerView.centerYAnchor),
            indicator.centerXAnchor.constraint(equalTo: strokeContainerView.centerXAnchor),
            indicator.widthAnchor.constraint(equalToConstant: frame),
            indicator.heightAnchor.constraint(equalToConstant: frame)
        ])
        strokeContainerView.bringSubviewToFront(forView)
    }

    public func hideCircleStroke() {
        indicator.stopAnimating()
        strokeContainerView.removeFromSuperview()
    }

    public func isAnimating() -> Bool {
        return indicator.isAnimating
    }

    public func configureLoaderWithBackgroud(on view: UIView, controller: UIViewController) {
        loaderBackgroundView = UIView()
        loaderBackgroundView?.alpha = 0
        loaderBackgroundView?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        loaderBackgroundView?.accessibilityIdentifier = "loaderBackgroundView.\(controller)"
        loaderBackgroundView?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loaderBackgroundView ?? UIView())
        loaderBackgroundView?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        loaderBackgroundView?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 20).isActive = true
        loaderBackgroundView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        loaderBackgroundView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        loaderBackgroundView?.fadeAnimationIn()
        showCircleStroke(indicator: loaderBackgroundView ?? UIView())
    }

    public func removeBackground() {
        loaderBackgroundView?.fadeAnimationOut(onCompletion: { _ in
            self.loaderBackgroundView?.removeFromSuperview()
            self.loaderBackgroundView = nil
        })
    }
}

