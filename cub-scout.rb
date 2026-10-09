# frozen_string_literal: true

class CubScout < Formula
  desc "GitOps explorer for agents: read-only evidence from your clusters"
  homepage "https://confighub.com"
  url "https://github.com/confighub/cub-scout/archive/refs/tags/v2.13.3.tar.gz"
  sha256 "1c77616be3186cf845677766105fd58fe8b4adb8c10ab83540a4330fb084d8a2"
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
