class MbCli < Formula
  desc "Command-line client for Metabase"
  homepage "https://github.com/metabase/metabase-cli"
  url "https://github.com/metabase/metabase-cli/archive/0a824792abefeb6b5e75bab190c019c37db8f8c1.tar.gz"
  version "0.3.0"
  sha256 "30aef4c0623e0e650003a069ec75e4314f6b78b915b22ae21b265acd5d923146"
  license "AGPL-3.0-only"
  head "https://github.com/metabase/metabase-cli.git", branch: "main"

  depends_on "bun" => :build
  depends_on "node"

  def install
    system "bun", "install"
    system "bun", "run", "build"

    # dist/cli.mjs keeps dependencies external (meaning the native @napi-rs/keyring
    # can't be bundled), so `packages/cli` is npm-packed and installed like a published
    # npm package. Yucky, but needed.

    cd "packages/cli" do
      system "npm", "install", *std_npm_args
    end

    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mb --version")
  end
end
