class Raisfast < Formula
  desc "The fastest CMS, easiest to deploy. Rust-powered high-performance BaaS and headless CMS with built-in blog, ecommerce, wallet, payment and 4 plugin engines."
  homepage "https://github.com/raisfast/raisfast"
  version "0.3.14"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/raisfast/raisfast/releases/download/v0.3.14/raisfast-aarch64-apple-darwin.tar.xz"
      sha256 "a29612a3b53c570f3d93f92b4f9e9e1dffa49934d32ced421faed6c76f0e4d84"
    end
    if Hardware::CPU.intel?
      url "https://github.com/raisfast/raisfast/releases/download/v0.3.14/raisfast-x86_64-apple-darwin.tar.xz"
      sha256 "fb78681059fa1b0737159fccf42b31b99ba3d5717e8dfd2cf83d8e561b098d23"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/raisfast/raisfast/releases/download/v0.3.14/raisfast-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "62b51d438327e5a97643afc2952e11d6942c257e04c351321fbddd2995dda935"
    end
    if Hardware::CPU.intel?
      url "https://github.com/raisfast/raisfast/releases/download/v0.3.14/raisfast-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8892bb2ab47c53c0c89cf6734c3b50a3ad078e8a9c2d9a7f227b4d67f678d073"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-pc-windows-gnu":              {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "raisfast"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "raisfast"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "raisfast"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "raisfast"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
