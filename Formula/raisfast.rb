class Raisfast < Formula
  desc "The last backend you'll ever need. Rust-powered headless CMS with built-in blog, ecommerce, wallet, payment and 4 plugin engines."
  homepage "https://github.com/raisfast/raisfast"
  version "0.2.15"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/raisfast/raisfast/releases/download/v0.2.15/raisfast-aarch64-apple-darwin.tar.xz"
      sha256 "dca0e3165ef815068923ab1ba520b19c7a25f2419bf82fb392ae5351488ad194"
    end
    if Hardware::CPU.intel?
      url "https://github.com/raisfast/raisfast/releases/download/v0.2.15/raisfast-x86_64-apple-darwin.tar.xz"
      sha256 "7b3946580c3c96c1489d59f153a4c311b3073b2063d3030e7f1e59aa8ed1adbc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/raisfast/raisfast/releases/download/v0.2.15/raisfast-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f7135f4616052acfad814d9bf0ffcf583a51003c8fcb1e0f07c7c475c1664025"
    end
    if Hardware::CPU.intel?
      url "https://github.com/raisfast/raisfast/releases/download/v0.2.15/raisfast-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "14f8eb1e5b2f49b7b53f90151b81b7317fe5109dfbc37c3f58505bf7b461c12d"
    end
  end

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
