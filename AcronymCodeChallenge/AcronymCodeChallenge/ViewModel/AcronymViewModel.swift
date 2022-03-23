//
//  AcronymViewModel.swift
//  AcronymCodeChallenge
//
//  Created by admin on 22/03/2022.
//

import Foundation

protocol AcronymViewModelType {
    var network: Network { get }
    var result: Acronym? { get }
    func bind(successBinding: @escaping () -> Void, failureBinding: @escaping (Error) -> Void)
    func searchAcronym(acronym: String)
    var count: Int { get }
    func fullForm(for index: Int) -> String?
}

typealias SuccessBinding = () -> Void
typealias FailureBinding = (Error) -> Void

class AcronymViewModel: AcronymViewModelType {
    
    var network: Network
    var result: Acronym? {
        didSet {
            self.successBinding?()
        }
    }
    
    private var successBinding: SuccessBinding?
    private var failureBinding: FailureBinding?
    
    var dispatchNetworkTask: DispatchWorkItem? {
        didSet {
            if let oldTask = oldValue { oldTask.cancel() }
            guard let task = self.dispatchNetworkTask else { return }
            DispatchQueue.global().asyncAfter(deadline: .now() + 2, execute: task)
        }
    }
    
    init(network: Network) {
        self.network = network
    }
    
    func bind(successBinding: @escaping () -> Void, failureBinding: @escaping (Error) -> Void) {
        self.successBinding = successBinding
        self.failureBinding = failureBinding
    }
    
    func searchAcronym(acronym: String) {

        guard !acronym.isEmpty else {
            self.result = nil
            self.dispatchNetworkTask = nil
            return
        }
        
        self.dispatchNetworkTask = DispatchWorkItem {
            self.network.getModel(request: NetworkParams.acronymSearch(acronym).urlRequest) { [weak self] (result: Result<[Acronym], Error>) in
                switch result {
                case .success(let result):
                    // decode sucess
                    if let value = result.first {
                        // true success
                        self?.result = value
                    } else {
                        self?.result = nil
                        self?.failureBinding?(NetworkError.emptyResult)
                    }
                case .failure(let error):
                    print(error)
                    self?.failureBinding?(error)
                }
            }
        }
    }
    
    var count: Int {
        return self.result?.lfs.count ?? 0
    }
    
    func fullForm(for index: Int) -> String? {
        guard index < (self.result?.lfs.count ?? 0) else { return nil }
        return self.result?.lfs[index].lf
    }

}
