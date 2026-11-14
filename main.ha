use fmt;
use os;
use io;

fn usage(stream: io::handle) void = {
	fmt::fprintf(stream, "Usage: rab [OPTIONS] [--] [path]\n")!;
};

fn handle_arg(arg: str) void = {
	fmt::printf("arg: {}\n", arg)!;
};

export fn main() void = {
	const args = os::args;

	if (len(args) < 2) {
		usage(os::stderr);
		os::exit(1);
	};

	for (let arg .. args) {
		handle_arg(arg);
	};
};
