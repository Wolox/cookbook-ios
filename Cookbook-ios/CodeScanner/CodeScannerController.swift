//
//  CodeScannerController.swift
//  Cookbook-ios
//
//  Created by Carolina Arcos on 2/11/20.
//  Copyright © 2020 Wolox. All rights reserved.
//

import UIKit
import AVFoundation

class CodeScannerController: GeneralViewController, AVCaptureMetadataOutputObjectsDelegate {
    // MARK: Properties
    @IBOutlet weak var cameraView: UIView!
    private lazy var _scanner: Scanner? = Scanner(withViewController: self,
                                                  view: cameraView,
                                                  codeOutputHandler: handleCode)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feature = Features.codeScanner
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        validateCameraAccess()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopScanner()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateCameraLayer()
    }
    
    // MARK: - Camera access
    func validateCameraAccess() {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { [unowned self] hasAccess in
            if UIImagePickerController.isSourceTypeAvailable(.camera) && hasAccess {
                self.startScanner()
            } else {
                let alert = UIAlertController(title: "No camera access",
                                              message: "You don't have a camera or the access was rejected",
                                              preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Camera Session handler
    // Call this method when you need to start the camera
    func startScanner() {
        updateCameraLayer()
        _scanner?.startCaptureSession()
    }
    
    // Call this method when you need to stop the camera
    func stopScanner() {
        _scanner?.stopCaptureSession()
    }
    
    // Updates the camera layer when the frame changes, e.g: changing device orientation
    func updateCameraLayer() {
        DispatchQueue.main.async {
            self._scanner?.previewLayer?.frame = self.view.layer.bounds
            self._scanner?.previewLayer?.connection?.videoOrientation = transformOrientation(orientation: UIApplication.shared.statusBarOrientation)
        }
    }
}

// MARK: - Capture Metadata Output Objects Delegate
extension CodeScannerController {
    private func handleCode(code: String) {
        print("SCANNED CODE: \(code)")
    }
    
    // MARK: - AVCaptureMetadataOutputObjects Delegate
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        _scanner?.scannerDelegate(output, didOutput: metadataObjects, from: connection)
    }
}
