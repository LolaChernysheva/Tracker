//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Lolita Chernysheva on 05.04.2024.
//  
//

import UIKit

final class OnboardingViewController: UIPageViewController {
    private lazy var pages: [UIViewController] =  {
        let firstPage = OnboardingPageViewController(
            backgroundImage: UIImage(named: "Onboarding-1") ?? UIImage(),
            titleString: "Отслеживайте только то, что хотите"
        )
        let secondPage = OnboardingPageViewController(
            backgroundImage: UIImage(named: "Onboarding-2") ?? UIImage(),
            titleString: "Даже если это не литры воды и йога"
        )
        return [firstPage, secondPage]
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        
        pageControl.currentPageIndicatorTintColor = .buttons
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private let startButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        setFirstController()
        setupStartButton()
        setupPageControll()
    }
    
    private func setFirstController() {
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
    }
    
    private func setupPageControll() {
        view.addSubview(pageControl)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -.pageControllBottomInsets)
        ])
    }
    
    private func setupStartButton() {
        view.addSubview(startButton)
        
        startButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .insets),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.insets),
            startButton.heightAnchor.constraint(equalToConstant: .buttonHeight),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -.buttonBottomInsets)
        ])
        
        startButton.layer.cornerRadius = .radius
        startButton.clipsToBounds = true
        startButton.backgroundColor = .buttons
        startButton.setTitle(NSLocalizedString("That's the technology!", comment: ""), for: .normal)
        startButton.addTarget(self, action: #selector(goToTrackersController), for: .touchUpInside)
    }
    
    @objc private func goToTrackersController() {
        let mainTabbarController = Assembler.mainScreenBuilder()
        mainTabbarController.modalPresentationStyle = .fullScreen
        present(mainTabbarController, animated: true)
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
                guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
                    return nil
                }
                
                let nextIndex = viewControllerIndex + 1
                
                guard nextIndex < pages.count else {
                    return nil
                }
                
                return pages[nextIndex]
    }
}

fileprivate extension CGFloat {
    static let radius: CGFloat = 16
    static let buttonHeight: CGFloat = 60
    static let insets: CGFloat = 20
    static let buttonBottomInsets: CGFloat = 50
    static let pageControllBottomInsets: CGFloat = 24
}
