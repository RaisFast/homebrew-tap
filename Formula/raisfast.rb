class Raisfast < Formula
  desc "The fastest CMS, easiest to deploy. Rust-powered high-performance BaaS and headless CMS with built-in blog, ecommerce, wallet, payment and 4 plugin engines."
  homepage "https://github.com/raisfast/raisfast"
  version "0.2.27"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/raisfast/raisfast/releases/download/v0.2.27/raisfast-aarch64-apple-darwin.tar.xz"
      sha256 "3249f61d02b35795eb03296e6bb0dca3cc813c1f9e4cd09b14bba20a8784d0f2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/raisfast/raisfast/releases/download/v0.2.27/raisfast-x86_64-apple-darwin.tar.xz"
      sha256 "89f545d286c713615e3ac0ecdebfd883eff42342f65b8721fad6e929fa86875f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/raisfast/raisfast/releases/download/v0.2.27/raisfast-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7bf2e81805c5936f1993d7ce504495ce9351fd85b9de2f47ef1f36f22606c916"
    end
    if Hardware::CPU.intel?
      url "https://github.com/raisfast/raisfast/releases/download/v0.2.27/raisfast-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2f0705b7c6e260254dc42022cb7531b1f2c6b7b9d06bfb59eefc9b8bd08273c6"
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
    bin.install "raisfast" if OS.mac? && Hardware::CPU.arm?
    bin.install "raisfast" if OS.mac? && Hardware::CPU.intel?
    bin.install "raisfast" if OS.linux? && Hardware::CPU.arm?
    bin.install "raisfast" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
