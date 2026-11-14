use fmt;
use os;
use io;
use strings;
use fs;
use types;
use bufio;

fn usage(stream: io::handle) void = {
	fmt::fprintf(stream, "Usage: rab [OPTIONS] [--] [path]\n")!;
};

fn handle_arg(arg: str) void = {
	if (strings::hasprefix(arg, '-')) {
		handle_flag(arg);
		return;
	};

	handle_file(arg);
};

fn handle_flag(flag: str) void = {
	if (strings::compare(flag, "-h") == 0 || strings::compare(flag, "--help") == 0) {
		usage(os::stdout);
		os::exit(0);
	};

	if (strings::compare(flag, "-v") == 0 || strings::compare(flag, "--version") == 0) {
		fmt::printf("rab 0.0.1\n")!;
		os::exit(0);
	};

	fmt::fprintf(os::stderr, "rab: invalid option '{}'\nTry 'rab --help' for more information.\n", flag)!;
	os::exit(1);
};

fn handle_file(path: str) void = {
	const file = match (os::open(path)) {
	case let file: io::file =>
		yield file;
	case let err: fs::error =>
		fmt::fatalf("Error opening {}: {}", path, fs::strerror(err));
	};
	defer io::close(file)!;

	const scan = bufio::newscanner(file, types::SIZE_MAX);
	defer bufio::finish(&scan);

	for (let i = 1u; true; i += 1) {
		const line = match (bufio::scan_line(&scan)!) {
		case io::EOF =>
			break;
		case let line: const str =>
			yield line;
		};
		fmt::printfln("{}\t{}", i, line)!;
	};
};

export fn main() void = {
	const args = os::args;

	if (len(args) < 2) {
		usage(os::stderr);
		os::exit(1);
	};

	for (let arg .. args[1..]) {
		handle_arg(arg);
	};
};
