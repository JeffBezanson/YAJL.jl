# This file comes from https://github.com/christopher-dG/YAJLBuilder/releases/tag/2.1.0

using BinaryProvider # requires BinaryProvider 0.3.0 or later

# Parse some basic command-line arguments
const verbose = "--verbose" in ARGS
const prefix = Prefix(get([a for a in ARGS if a != "--verbose"], 1, joinpath(@__DIR__, "usr")))
products = [
    LibraryProduct(prefix, ["libyajl"], :libyajl),
]

# Download binaries from hosted location
bin_prefix = "https://github.com/christopher-dG/YAJLBuilder/releases/download/2.1.0"

# Listing of files generated by BinaryBuilder:
download_info = Dict(
    Linux(:aarch64, libc=:glibc) => ("$bin_prefix/YAJL.v2.1.0.aarch64-linux-gnu.tar.gz", "5a9bd9edec0d0fff6ffd713bb435d0544ac8cd23f94f3682f5dbe5262c972603"),
    Linux(:aarch64, libc=:musl) => ("$bin_prefix/YAJL.v2.1.0.aarch64-linux-musl.tar.gz", "9cca3c16041acb03c1d0338128b8a59795e15473be9db512367cd3b5036fa0db"),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf) => ("$bin_prefix/YAJL.v2.1.0.arm-linux-gnueabihf.tar.gz", "97018e72c5dab98b0289f7539f4d1809c9a0b27e30695674d408658dd8894341"),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf) => ("$bin_prefix/YAJL.v2.1.0.arm-linux-musleabihf.tar.gz", "20545da865e6ead1bb5ffec7ac5a389e74972f1010dfcf00d2b5f3597961663a"),
    Linux(:i686, libc=:glibc) => ("$bin_prefix/YAJL.v2.1.0.i686-linux-gnu.tar.gz", "8fd0f107fb46662c9e5746deceaf3ce298c1cff51088ee7cbffeef8dffbf9ff7"),
    Linux(:i686, libc=:musl) => ("$bin_prefix/YAJL.v2.1.0.i686-linux-musl.tar.gz", "38cfab3abf590e35215d295d382e619bf80dcc9ba9d9841eefe71daa713d3a84"),
    Linux(:powerpc64le, libc=:glibc) => ("$bin_prefix/YAJL.v2.1.0.powerpc64le-linux-gnu.tar.gz", "5a7b3ba33f1ebac5be90adb944444d1944e7799aa901e1f06c0405ae709f1e69"),
    MacOS(:x86_64) => ("$bin_prefix/YAJL.v2.1.0.x86_64-apple-darwin14.tar.gz", "d5fc78a32de1cf57d4419145e61fc17291e2c129947b1be483a136739b063701"),
    Linux(:x86_64, libc=:glibc) => ("$bin_prefix/YAJL.v2.1.0.x86_64-linux-gnu.tar.gz", "23b39d3332a12fda5ae2144c7da7569ede7f4b870f5d03e84dbee3c199415c9c"),
    Linux(:x86_64, libc=:musl) => ("$bin_prefix/YAJL.v2.1.0.x86_64-linux-musl.tar.gz", "ebdc3a788a4ec630d5fa86c89b0e946ae224424d9c7d738e6b1b1bf5c0db5f62"),
    FreeBSD(:x86_64) => ("$bin_prefix/YAJL.v2.1.0.x86_64-unknown-freebsd11.1.tar.gz", "4b7b18e74c349c96205828b2cb2c03b93ff2e7a37480df238937a1abe6b5924a"),
)

# Install unsatisfied or updated dependencies:
unsatisfied = any(!satisfied(p; verbose=verbose) for p in products)
dl_info = choose_download(download_info, platform_key_abi())
if dl_info === nothing && unsatisfied
    # If we don't have a compatible .tar.gz to download, complain.
    # Alternatively, you could attempt to install from a separate provider,
    # build from source or something even more ambitious here.
    error("Your platform (\"$(Sys.MACHINE)\", parsed as \"$(triplet(platform_key_abi()))\") is not supported by this package!")
end

# If we have a download, and we are unsatisfied (or the version we're
# trying to install is not itself installed) then load it up!
if unsatisfied || !isinstalled(dl_info...; prefix=prefix)
    # Download and install binaries
    install(dl_info...; prefix=prefix, force=true, verbose=verbose)
end

# Write out a deps.jl file that will contain mappings for our products
write_deps_file(joinpath(@__DIR__, "deps.jl"), products, verbose=verbose)
