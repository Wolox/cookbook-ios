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
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            showErrorAlert(message: "You don't have a camera")
            return
        }
        
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { [unowned self] hasAccess in
            guard hasAccess else {
                self.showErrorAlert(message: "Your camera access was rejected. Plase change this configuration in Settings")
                return
            }
            
            DispatchQueue.main.async {
                self.startScanner()
            }
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "No camera access",
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
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
        let alert = UIAlertController(title: "Scanned code",
                                      message: code,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Scan again", style: .cancel, handler: { _ in self.validateCameraAccess() })
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - AVCaptureMetadataOutputObjects Delegate
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        _scanner?.scannerDelegate(output, didOutput: metadataObjects, from: connection)
    }
}
