//
//  MainVMSpec.swift
//  GithubSearchTests
//
//  Created by Mephrine on 2020/06/23.
//  Copyright © 2020 Mephrine. All rights reserved.
//

import Quick
import Nimble
import RxSwift
import RxTest
import RxCocoa
import RxOptional
@testable import GithubSearch

class MainVMSpec: QuickSpec {
    override func spec() {
        var service: MainServiceProtocol!
        var disposeBag: DisposeBag!
        // 모든 example가 실행되기 전에 실행.
        beforeSuite {
            service = MainServiceStub()
            disposeBag = DisposeBag()
        }
        
        // 모든 example가 실행되고난 후에 실행.
        afterSuite {
            
        }
        
        context("request API") {
            it("it searchUser") {
                do {
                    let searchUser = try service.fetchSearchUser(searchText: "", .match, .desc, 1).toBlocking().first()
                    expect(searchUser?.items?.first?.login!).to(equal("swift"), description: "firstName is Mephrine.")
                } catch let error {
                    print("error### : \(error)")
                    fail("searchUser blocking error")
                }
            }
            
            it("it userInfo") {
                do {
                    let userInfo = try service.fetchUserInfo(userName: "").toBlocking().first()
                    expect(userInfo?.publicRepos).to(equal(6), description: "public_repos == 6")
                } catch let error {
                    print("error### : \(error)")
                    fail("userInfo blocking error")
                }
            }
            
            it("it List Data") {
                do {
                    let userInfo = try service.fetchSearchUser(searchText: "", .match, .desc, 1)
                        .map { $0.items }
                        .asObservable()
                        .filterNil()
                        .flatMap{
                            Observable.combineLatest($0.map { item in
                                service.fetchUserInfo(userName: item.login!).asObservable()
                            })
                        }.toBlocking().first()
                    expect(userInfo?.first?.name).to(equal("Mephrine"), description: "firstName is Mephrine.")
                } catch let error {
                    print("error### : \(error)")
                    fail("searchUser blocking error")
                }
            }
        }
    }
}
