class Raisfast < Formula
  desc "The fastest CMS, easiest to deploy. Rust-powered high-performance BaaS and headless CMS with built-in blog, ecommerce, wallet, payment and 4 plugin engines."
  homepage "https://github.com/raisfast/raisfast"
  version "0.3.12"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/raisfast/raisfast/releases/download/v0.3.12/raisfast-aarch64-apple-darwin.tar.xz"
      sha256 "2858ee6fd060f24c8043a9f6027560cd9481bc1c45ec24671072813bc4a80464"
    end
    if Hardware::CPU.intel?
      url "https://github.com/raisfast/raisfast/releases/download/v0.3.12/raisfast-x86_64-apple-darwin.tar.xz"
      sha256 "7d52df9a8a8c21e3d837c17189d8b3012f9373059d03a0218bf697fc321bba21"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/raisfast/raisfast/releases/download/v0.3.12/raisfast-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "14f4b1901005e1510d9fa428e3761510a32d41ad06ac859efa8d53fbdddbad28"
    end
    if Hardware::CPU.intel?
      url "https://github.com/raisfast/raisfast/releases/download/v0.3.12/raisfast-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e7fda7f9b15e6ef1cb5b171c4d62d5ae30ad37c1836b681b3a060309de70ab75"
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
