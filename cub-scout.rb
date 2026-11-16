# frozen_string_literal: true

class CubScout < Formula
  desc "GitOps explorer for agents: read-only evidence from your clusters"
  homepage "https://confighub.com"
  url "https://github.com/confighub/cub-scout/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "3ed2dc0db2d6912da78f6ff9619729e2dbdac82d5ab598976d8674a0588d760e"
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
