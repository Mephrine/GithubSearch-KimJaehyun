//
//  MainVC.swift
//  GithubSearch
//
//  Created by Mephrine on 2020/06/22.
//  Copyright © 2020 Mephrine. All rights reserved.
//

import ReactorKit
import Reusable
import RxOptional
import RxSwift
import RxDataSources
import RxAnimated
import SnapKit
import Then
import UIKit

/**
 # (C) MainVC
 - Author: Mephrine
 - Date: 20.06.22
 - Note: 메인화면 ViewController
 */
final class MainVC: BaseVC, StoryboardView, StoryboardBased {
    //MARK : - Variable
    // TableView DataSource
    typealias MainDataSource = RxTableViewSectionedReloadDataSource<MainTableViewSection>
    private var dataSource: MainDataSource {
        return .init(configureCell: { (dataSource, tableView, indexPath, item) -> UITableViewCell in
            let cell: UserCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(item: item)
            
            return cell
        })
    }
    
    //MARK: - View
    private lazy var searchBar = UISearchBar(frame: .zero).then {
        $0.placeholder = STR_SEARCH_PLACE_HOLDER
        $0.searchBarStyle = .prominent
        $0.sizeToFit()
        $0.isTranslucent = false
        
        if #available(iOS 13.0, *) {
            $0.setShowsScope(true, animated: true)
        }
    }
    
    private lazy var tvUserList = UITableView(frame: .zero, style: .plain).then {
        $0.register(cellType: UserCell.self)
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.rowHeight = 90
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.keyboardDismissMode = .onDrag
        if #available(iOS 11.0, *) {
            $0.contentInsetAdjustmentBehavior = .never
        }
    }
    
    private lazy var vNoData = UIView(frame: .zero).then {
        $0.backgroundColor = .white
    }
    
    private lazy var lbNoData = UILabel(frame: .zero).then {
        $0.backgroundColor = .clear
        $0.textColor = .black
        $0.text = STR_SEARCH_NO_INPUT
        $0.font = Utils.Font(.Bold, size: 24)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private lazy var vLoading =  UIActivityIndicatorView(style: .gray).then {
        $0.frame = CGRect(x: 0, y: 0, width: self.tvUserList.bounds.width, height: 44)
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Async.main(after: ANIMATION_DURATION * 2) { [weak self] in
            self?.searchBar.becomeFirstResponder()
        }
        
    }
    
    //MARK: - Bind
    func bind(reactor: MainVM) {
        
        // action
        // searchBar에 텍스트 변경 옵션이 일어날 경우
        self.searchBar.rx.text
            .map{ $0?.trimSide }
            .asDriver(onErrorJustReturn: "")
            .debounce(RxTimeInterval.milliseconds(500))
            .distinctUntilChanged()
            .map{ Reactor.Action.inputUserName(userName: $0 ?? "") }
            .drive(reactor.action)
            .disposed(by: disposeBag)
        
        //state
        // TableView
        reactor.state
            .map{ $0.userList }
            .bind(to: self.tvUserList.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // 데이터가 없거나 SearchBar 검색어가 비어있는 경우
        reactor.state.map{ $0.noDataText }
            .distinctUntilChanged()
            .observeOn(Schedulers.main)
            .subscribe(onNext: { [weak self] in
                self?.vNoData.rx.animated.fade(duration: ANIMATION_DURATION).isHidden.onNext($0.isEmpty)
                self?.lbNoData.rx.animated.fade(duration: ANIMATION_DURATION).text.onNext($0)
            })
            .disposed(by: disposeBag)
        
        // 재검색 시, 스크롤 상단으로 올리기
        reactor.isSearchReload
            .filter{ $0 == true }
            .filter{ _ in !reactor.isEmptyCurrentUserList() }
            .observeOn(Schedulers.main)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.tvUserList.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }).disposed(by: disposeBag)
        
        // 로딩바 관리
        reactor.isLoading
            .distinctUntilChanged()
            .observeOn(Schedulers.main)
            .subscribe(onNext:{ [weak self] in
                guard let self = self else { return }
                if $0 {
                    self.vLoading.isHidden = false
                    self.vLoading.startAnimating()
                    self.tvUserList.tableFooterView = self.vLoading
                } else {
                    self.vLoading.stopAnimating()
                    self.tvUserList.tableFooterView = nil
                    self.vLoading.isHidden = true
                }
            }).disposed(by: disposeBag)
        
        // e.g.
        // 마지막 Section의 마지막 Row가 보여질 경우 다음 페이지 데이터 불러오기
        self.tvUserList.rx.willDisplayCell
            .filter{ _ in reactor.chkEnablePaging() }
            .subscribe(onNext: { [weak self] cell, indexPath in
                guard let self = self else { return }
                let lastSectionIndex = self.tvUserList.numberOfSections - 1
                let lastRowIndex = self.tvUserList.numberOfRows(inSection: lastSectionIndex) - 1
                if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
                    self.reactor?.action.onNext(.loadMore)
                }
            }).disposed(by: disposeBag)
    }
    
    //MARK: - UI
    override func initView() {
        self.view.addSubview(self.searchBar)
        self.view.addSubview(self.tvUserList)
        self.view.addSubview(self.vNoData)
        self.vNoData.addSubview(self.lbNoData)
        
        self.constraints()
    }
    
    /**
     # constraints
     - Author: Mephrine
     - Date: 20.06.22
     - Parameters:
     - Returns:
     - Note: 오토레이아웃 적용
    */
    func constraints() {
        self.searchBar.snp.makeConstraints { [weak self] in
            guard let self = self else { return }
            if #available(iOS 11.0, *) {
                $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            } else {
                $0.top.equalTo(self.topLayoutGuide.snp.bottom)
            }
            $0.left.right.equalToSuperview()
            $0.height.equalTo(self.searchBar.bounds.height)
        }
        self.tvUserList.snp.makeConstraints{ [weak self] in
            guard let self = self else { return }
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(self.searchBar.snp.bottom)
        }
        
        self.lbNoData.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview().offset(-40)
        }
        
        self.vNoData.snp.makeConstraints { [weak self] in
            guard let self = self else { return }
            $0.left.equalTo(self.tvUserList.snp.left)
            $0.right.equalTo(self.tvUserList.snp.right)
            $0.bottom.equalTo(self.tvUserList.snp.bottom)
            $0.top.equalTo(self.tvUserList.snp.top)
        }
    }
}

