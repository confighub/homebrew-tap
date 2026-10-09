# frozen_string_literal: true

class CubScout < Formula
  desc "GitOps explorer for agents: read-only evidence from your clusters"
  homepage "https://confighub.com"
  url "https://github.com/confighub/cub-scout/archive/refs/tags/v2.13.4.tar.gz"
  sha256 "b8db96379b7ed4a85d64065429a00d7e286808fc4fe4c6962184fbd34db12e19"
  license "MIT"

  depends_on "go" => :build
  deny_network_access!

  def fetch
    ENV["GOTOOLCHAIN"] = "local"
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    ENV["GOTOOLCHAIN"] = "local"
    system "go", "build", *std_go_args(ldflags: "-X main.BuildTag=#{version}"), "./cmd/cub-scout"
    bin.install_symlink "cub-scout" => "kubectl-cub_scout"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cub-scout version")
    assert_match version.to_s, shell_output("#{bin}/kubectl-cub_scout version")
    assert_match "Usage:", shell_output("#{bin}/cub-scout trace --help")
  end
end
