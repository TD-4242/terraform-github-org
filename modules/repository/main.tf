resource "github_repository" "repository" {
  name         = "${var.name}"
  description  = "${local.description}"
  homepage_url = "${local.homepage_url}"

  private            = false
  has_issues         = true
  has_wiki           = "${var.has_wiki}"
  has_projects       = "${var.has_projects}"
  allow_merge_commit = true
  allow_squash_merge = true
  allow_rebase_merge = true
  has_downloads      = false
  auto_init          = false
  archived           = "${var.archived}"
  topics             = "${local.topics}"
}

resource "github_branch_protection" "repository_master" {
  repository     = "${var.name}"
  branch         = "master"
  enforce_admins = "${var.enforce_admins}"

  required_status_checks {
    strict   = "${var.require_ci_pass}"
    contexts = ["${var.status_checks}"]
  }

  required_pull_request_reviews {
    dismiss_stale_reviews      = "${var.dismiss_stale_reviews}"
    require_code_owner_reviews = "${var.require_code_owner_reviews}"
  }

  depends_on = ["github_repository.repository"]
}

resource "github_team_repository" "repository_everyone" {
  team_id    = "${var.chef_de_partie}"
  repository = "${github_repository.repository.name}"
  permission = "${var.everyone_permission}"
}

resource "github_team_repository" "restricted_access" {
  team_id    = "${var.cookbook_team}"
  repository = "${github_repository.repository.name}"
  permission = "${var.team_permission}"
}
