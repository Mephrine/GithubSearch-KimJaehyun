//
//  UserInfoDummy.swift
//  GithubSearchTests
//
//  Created by Mephrine on 2020/06/23.
//  Copyright © 2020 Mephrine. All rights reserved.
//

import Foundation
@testable import GithubSearch

struct UserInfoDummy {
    static let jsonData: UserInfo? = jsonStringToData(
        """
    {
      "login": "Mephrine",
      "id": 10842491,
      "node_id": "MDQ6VXNlcjEwODQyNDkx",
      "avatar_url": "https://avatars1.githubusercontent.com/u/10842491?v=4",
      "gravatar_id": "",
      "url": "https://api.github.com/users/Mephrine",
      "html_url": "https://github.com/Mephrine",
      "followers_url": "https://api.github.com/users/Mephrine/followers",
      "following_url": "https://api.github.com/users/Mephrine/following{/other_user}",
      "gists_url": "https://api.github.com/users/Mephrine/gists{/gist_id}",
      "starred_url": "https://api.github.com/users/Mephrine/starred{/owner}{/repo}",
      "subscriptions_url": "https://api.github.com/users/Mephrine/subscriptions",
      "organizations_url": "https://api.github.com/users/Mephrine/orgs",
      "repos_url": "https://api.github.com/users/Mephrine/repos",
      "events_url": "https://api.github.com/users/Mephrine/events{/privacy}",
      "received_events_url": "https://api.github.com/users/Mephrine/received_events",
      "type": "User",
      "site_admin": false,
      "name": "Mephrine",
      "company": null,
      "blog": "",
      "location": null,
      "email": null,
      "hireable": null,
      "bio": null,
      "twitter_username": null,
      "public_repos": 6,
      "public_gists": 0,
      "followers": 0,
      "following": 5,
      "created_at": "2015-02-04T04:26:50Z",
      "updated_at": "2020-06-23T03:38:20Z"
    }
    """
    )
}


