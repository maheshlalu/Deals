//
//  TutorialPageController.swift
//  Walk2Deals
//
//  Created by apple on 21/12/17.
//  Copyright © 2017 ongo. All rights reserved.
//

import UIKit

class TutorialPageController: UIPageViewController ,UIPageViewControllerDelegate,UIPageViewControllerDataSource {
    var pageControl = UIPageControl()
    var listOfViewControllers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        // Do any additional setup after loading the view.
        
        
        let redView =    UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LaunchViewController") as? LaunchViewController
        //redView?.pageIndex = 0
    
        listOfViewControllers.append(self.addNavController(viewCntl: redView!))
        
        let blueView =    UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Launch1ViewController") as? Launch1ViewController
       // redView?.pageIndex = 1

        listOfViewControllers.append(self.addNavController(viewCntl: blueView!))
        
        self.configurePageControl()
        
        //Step 5
        self.setViewControllers([listOfViewControllers.first!], direction: .forward, animated: false) { (value) in
            
        }
    }
    
    func addNavController(viewCntl:UIViewController)->UINavigationController{
        let nav = UINavigationController(rootViewController: viewCntl)
        nav.navigationBar.isHidden = true
        return nav
    }
    
    
    //Step 4 Create pager controller
    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 50,width: UIScreen.main.bounds.width,height: 50))
        self.pageControl.numberOfPages = listOfViewControllers.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.blue
        self.pageControl.pageIndicatorTintColor = UIColor.blue
        self.pageControl.currentPageIndicatorTintColor = UIColor.red
        self.view.addSubview(pageControl)
    }
    
    //Step 6: Implement the pager delegate And Datasource
    
    
    // MARK: Delegate methords
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = listOfViewControllers.index(of: pageContentViewController)!
    }
    
    //Step :7
    // MARK: Data source functions.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = listOfViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
           // return listOfViewControllers.last
            // Uncommment the line below, remove the line above if you don't want the page control to loop.
             return nil
        }
        
        guard listOfViewControllers.count > previousIndex else {
            return nil
        }
        
        return listOfViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = listOfViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = listOfViewControllers.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
           // return listOfViewControllers.first
            // Uncommment the line below, remove the line above if you don't want the page control to loop.
             return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return listOfViewControllers[nextIndex]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
