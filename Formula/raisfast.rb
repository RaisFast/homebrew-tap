class Raisfast < Formula
  desc "The fastest CMS, easiest to deploy. Rust-powered high-performance BaaS and headless CMS with built-in blog, ecommerce, wallet, payment and 4 plugin engines."
  homepage "https://github.com/raisfast/raisfast"
  version "0.3.11"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/raisfast/raisfast/releases/download/v0.3.11/raisfast-aarch64-apple-darwin.tar.xz"
      sha256 "9d13137185ced75a223e830284f66059436c160bc5bf21d694fd1053cc5c6eb0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/raisfast/raisfast/releases/download/v0.3.11/raisfast-x86_64-apple-darwin.tar.xz"
      sha256 "6354f1a3433dbe0a19cd5625c59f2f3671512d5a0636b3083cc6e2dd5854e138"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/raisfast/raisfast/releases/download/v0.3.11/raisfast-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e0665b1370252502fc191920c84f5ff657efb0b7254768f5eff6d37e1ac84767"
    end
    if Hardware::CPU.intel?
      url "https://github.com/raisfast/raisfast/releases/download/v0.3.11/raisfast-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6f7d01646583309413b05b7ad31323fef1ccf8442f048f6d4b494c2dfbe0331a"
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
